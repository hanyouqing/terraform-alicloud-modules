variable "create_directory" {
  type        = bool
  description = "Create a CloudSSO directory. Only one directory is typically allowed per master account / region pairing."
  default     = false
}

variable "directory_id" {
  type        = string
  description = "Existing CloudSSO directory ID when create_directory is false"
  default     = null
}

variable "directory_name" {
  type        = string
  description = "Directory name when create_directory is true"
  default     = null
}

variable "mfa_authentication_status" {
  type        = string
  description = "Directory MFA status (Enabled / Disabled). Applied when create_directory is true."
  default     = null
}

variable "scim_synchronization_status" {
  type        = string
  description = "SCIM sync status (Enabled / Disabled). Applied when create_directory is true."
  default     = null
}

variable "directory_global_access_status" {
  type        = string
  description = "Directory global access status when create_directory is true"
  default     = null
}

variable "saml_identity_provider_configuration" {
  type = object({
    encoded_metadata_document = optional(string, null)
    sso_status                = optional(string, null)
    want_request_signed       = optional(bool, null)
    binding_type              = optional(string, null)
    entity_id                 = optional(string, null)
    login_url                 = optional(string, null)
  })
  description = "External SAML IdP for CloudSSO (org federation). Prefer metadata document from Okta/Azure AD/etc. Only applied when create_directory is true."
  default     = null
}

variable "saml_service_provider" {
  type = object({
    authn_sign_algo             = optional(string, null)
    certificate_type            = optional(string, null)
    support_encrypted_assertion = optional(bool, null)
  })
  description = "Optional CloudSSO SAML SP settings (ACS/entity are computed). Applied when create_directory is true."
  default     = null
}

variable "login_preference" {
  type = object({
    allow_user_to_get_credentials = optional(bool, null)
    login_network_masks           = optional(string, null)
  })
  description = "Optional CloudSSO login preference. Applied when create_directory is true."
  default     = null
}

variable "mfa_authentication_setting_info" {
  type = object({
    mfa_authentication_advance_settings = optional(string, null)
    operation_for_risk_login            = optional(string, null)
  })
  description = "Optional MFA advance settings. Applied when create_directory is true."
  default     = null
}

variable "password_policy" {
  type = object({
    max_login_attempts            = optional(number, null)
    max_password_age              = optional(number, null)
    min_password_different_chars  = optional(number, null)
    min_password_length           = optional(number, null)
    password_not_contain_username = optional(bool, null)
    password_reuse_prevention     = optional(number, null)
  })
  description = "Optional CloudSSO local-user password policy. Prefer SAML IdP; applied when create_directory is true."
  default     = null
}

variable "user_provisioning_configuration" {
  type = object({
    default_landing_page = optional(string, null)
    session_duration     = optional(string, null)
  })
  description = "Optional user provisioning defaults. Applied when create_directory is true."
  default     = null
}

variable "scim_server_credentials" {
  type = map(object({
    status                 = optional(string, "Enabled")
    credential_secret_file = optional(string, null)
  }))
  description = "Optional SCIM server credentials for IdP user provisioning into CloudSSO."
  default     = {}
}

variable "users" {
  type = map(object({
    user_name                   = string
    display_name                = optional(string, null)
    email                       = optional(string, null)
    first_name                  = optional(string, null)
    last_name                   = optional(string, null)
    description                 = optional(string, null)
    status                      = optional(string, null)
    password                    = optional(string, null)
    mfa_authentication_settings = optional(string, null)
    tags                        = optional(map(string), {})
  }))
  description = "Map of CloudSSO users. Treat password as confidential; prefer IdP federation in production."
  default     = {}
}

variable "groups" {
  type = map(object({
    group_name  = string
    description = optional(string, null)
  }))
  description = "Map of CloudSSO groups"
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

variable "access_configurations" {
  type = map(object({
    access_configuration_name        = string
    description                      = optional(string, null)
    session_duration                 = optional(number, null)
    relay_state                      = optional(string, null)
    force_remove_permission_policies = optional(bool, null)
    permission_policies = optional(list(object({
      permission_policy_name     = string
      permission_policy_type     = string
      permission_policy_document = optional(string, null)
    })), [])
  }))
  description = "Map of access configurations (permission sets). permission_policy_type is System or Inline."
  default     = {}
}

variable "access_assignments" {
  type = map(object({
    access_configuration_key = optional(string, null)
    access_configuration_id  = optional(string, null)
    principal_type           = string
    principal_user_key       = optional(string, null)
    principal_group_key      = optional(string, null)
    principal_id             = optional(string, null)
    target_id                = string
    target_type              = optional(string, "RD-Account")
    deprovision_strategy     = optional(string, null)
  }))
  description = "Assign an access configuration to a user or group on a resource directory account (target_id). Prefer principal_*_key for principals created in this module."
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.access_assignments : contains(["User", "Group"], v.principal_type)
    ])
    error_message = "access_assignments.*.principal_type must be User or Group."
  }
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
  description = "Additional tags merged into ManagedBy/Module/Project/Environment (applied where the API supports tags)"
  default     = {}
}
