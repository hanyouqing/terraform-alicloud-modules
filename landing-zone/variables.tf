variable "create_resource_directory" {
  type        = bool
  description = "Create a Resource Directory on this (management/master) account. Set false if RD already exists."
  default     = false
}

variable "enable_default_structure" {
  type        = bool
  description = "Create the opinionated top-level folders (Core, Infrastructure, Security, Workloads)"
  default     = true
}

variable "enable_workload_children" {
  type        = bool
  description = "When enable_default_structure is true, also create Production and NonProduction under Workloads"
  default     = true
}

variable "folder_names" {
  type = object({
    core           = optional(string, "Core")
    infrastructure = optional(string, "Infrastructure")
    security       = optional(string, "Security")
    workloads      = optional(string, "Workloads")
    production     = optional(string, "Production")
    non_production = optional(string, "NonProduction")
  })
  description = "Display names for the default folder layout (customize without changing folder keys)"
  default     = {}
}

variable "additional_folders" {
  type = map(object({
    folder_name       = string
    parent_folder_key = optional(string, null)
    parent_folder_id  = optional(string, null)
  }))
  description = "Extra folders beyond the default structure. parent_folder_key references a primary folder key (core/infrastructure/security/workloads/workloads_production/workloads_non_production), or set parent_folder_id directly."
  default     = {}
}

variable "member_accounts" {
  type = map(object({
    display_name        = string
    folder_key          = string
    payer_account_id    = optional(string, null)
    account_name_prefix = optional(string, null)
  }))
  description = "Member accounts to create. folder_key must match a folder key (e.g. core, security, workloads_production)."
  default     = {}
}

variable "create_baseline_policies" {
  type        = bool
  description = "Create and attach opinionated baseline control policies"
  default     = false
}

variable "enable_deny_leave_organization" {
  type        = bool
  description = "Baseline: Deny members leaving the Resource Directory"
  default     = true
}

variable "enable_protect_rd_access_role" {
  type        = bool
  description = "Baseline: Deny mutating ResourceDirectoryAccountAccessRole"
  default     = true
}

variable "baseline_policy_effect_scope" {
  type        = string
  description = "effect_scope for baseline control policies: RAM or All"
  default     = "RAM"

  validation {
    condition     = contains(["RAM", "All"], var.baseline_policy_effect_scope)
    error_message = "baseline_policy_effect_scope must be RAM or All."
  }
}

variable "baseline_attach_folder_keys" {
  type        = list(string)
  description = "Folder keys that receive baseline policy attachments (default: Core, Security, Workloads)"
  default     = ["core", "security", "workloads"]
}

variable "delegated_administrators" {
  type = map(object({
    account_id        = optional(string, null)
    account_key       = optional(string, null)
    service_principal = string
  }))
  description = "Delegated administrators for trusted services. Provide account_id or account_key (key into member_accounts)."
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "management"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags merged onto tagged resources"
  default     = {}
}
