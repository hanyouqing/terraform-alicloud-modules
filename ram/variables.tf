variable "users" {
  type = map(object({
    name                    = optional(string, null)
    display_name            = optional(string, null)
    mobile                  = optional(string, null)
    email                   = optional(string, null)
    comments                = optional(string, null)
    create_login_profile    = optional(bool, false)
    password                = optional(string, null)
    password_reset_required = optional(bool, true)
    mfa_bind_required       = optional(bool, true)
    create_access_key       = optional(bool, false)
    access_key_status       = optional(string, "Active")
  }))
  description = "Map of RAM users. Prefer SSO/roles over access keys in production. Treat password as confidential."
  default     = {}
}

variable "roles" {
  type = map(object({
    name                 = optional(string, null)
    document             = string
    description          = optional(string, null)
    max_session_duration = optional(number, 3600)
    force                = optional(bool, false)
  }))
  description = "Map of RAM roles with assume-role policy documents"
  default     = {}
}

variable "policies" {
  type = map(object({
    policy_name     = optional(string, null)
    policy_document = string
    description     = optional(string, null)
    rotate_strategy = optional(string, "None")
  }))
  description = "Map of custom RAM policies"
  default     = {}
}

variable "groups" {
  type = map(object({
    name     = optional(string, null)
    comments = optional(string, null)
  }))
  description = "Map of RAM groups"
  default     = {}
}

variable "group_memberships" {
  type = map(object({
    group_key = string
    user_keys = list(string)
  }))
  description = "Map of group memberships referencing keys in users and groups"
  default     = {}
}

variable "user_policy_attachments" {
  type = map(object({
    user_key    = string
    policy_key  = optional(string, null)
    policy_name = optional(string, null)
    policy_type = optional(string, "Custom")
  }))
  description = "Attach policies to users. Use policy_key for module policies or policy_name for existing policies."
  default     = {}
}

variable "role_policy_attachments" {
  type = map(object({
    role_key    = string
    policy_key  = optional(string, null)
    policy_name = optional(string, null)
    policy_type = optional(string, "Custom")
  }))
  description = "Attach policies to roles. Use policy_key for module policies or policy_name for existing policies."
  default     = {}
}

variable "group_policy_attachments" {
  type = map(object({
    group_key   = string
    policy_key  = optional(string, null)
    policy_name = optional(string, null)
    policy_type = optional(string, "Custom")
  }))
  description = "Attach policies to groups. Use policy_key for module policies or policy_name for existing policies."
  default     = {}
}

variable "saml_providers" {
  type = map(object({
    saml_provider_name            = optional(string, null)
    encodedsaml_metadata_document = string
    description                   = optional(string, null)
  }))
  description = "RAM SAML IdP providers (single-account federation). Metadata is Base64-encoded IdP XML. Pair with a role trust policy using sts:AssumeRoleWithSAML."
  default     = {}
}

variable "oidc_providers" {
  type = map(object({
    oidc_provider_name  = optional(string, null)
    issuer_url          = string
    client_ids          = optional(list(string), [])
    fingerprints        = optional(list(string), [])
    description         = optional(string, null)
    issuance_limit_time = optional(number, null)
  }))
  description = "IMS OIDC IdP providers (e.g. GitHub Actions, Okta OIDC). Pair with role trust using sts:AssumeRoleWithOIDC."
  default     = {}
}

variable "account_alias" {
  type        = string
  description = "Optional RAM account alias (console sign-in domain prefix)"
  default     = null
}

variable "password_policy" {
  type = object({
    hard_expiry                          = optional(bool, null)
    max_login_attemps                    = optional(number, null)
    max_password_age                     = optional(number, null)
    minimum_password_different_character = optional(number, null)
    minimum_password_length              = optional(number, null)
    password_not_contain_user_name       = optional(bool, null)
    password_reuse_prevention            = optional(number, null)
    require_lowercase_characters         = optional(bool, null)
    require_numbers                      = optional(bool, null)
    require_symbols                      = optional(bool, null)
    require_uppercase_characters         = optional(bool, null)
  })
  description = "Optional account-wide RAM password policy (singleton). Set to null to leave unmanaged."
  default     = null
}

variable "security_preference" {
  type = object({
    allow_user_to_change_password           = optional(bool, null)
    allow_user_to_login_with_passkey        = optional(bool, null)
    allow_user_to_manage_access_keys        = optional(bool, null)
    allow_user_to_manage_mfa_devices        = optional(bool, null)
    allow_user_to_manage_personal_ding_talk = optional(bool, null)
    enable_save_mfa_ticket                  = optional(bool, null)
    enforce_mfa_for_login                   = optional(bool, null)
    login_network_masks                     = optional(string, null)
    login_session_duration                  = optional(number, null)
    max_idle_days_for_access_keys           = optional(number, null)
    max_idle_days_for_users                 = optional(number, null)
    mfa_operation_for_login                 = optional(string, null)
    operation_for_risk_login                = optional(string, null)
    verification_types                      = optional(list(string), null)
  })
  description = "Optional account-wide RAM security preference (singleton). Prefer enforce_mfa_for_login in production."
  default     = null
}

variable "project" {
  type        = string
  description = "Project name for tagging / operational metadata"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging / operational metadata"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (RAM resources have limited tag support; retained for module consistency)"
  default     = {}
}
