variable "create_resource_directory" {
  type        = bool
  description = "Create the Resource Directory (only once per master account). Set false when the directory already exists."
  default     = false
}

variable "folders" {
  type = map(object({
    folder_name       = string
    parent_folder_key = optional(string, null)
    parent_folder_id  = optional(string, null)
    tags              = optional(map(string), {})
  }))
  description = <<-EOT
    Map of Resource Manager folders.
    Root-level: leave parent_folder_key and parent_folder_id null (under Root).
    One nesting level: set parent_folder_key to another key in this map that is root-level.
    Deeper nesting or existing parents: pass parent_folder_id (e.g. from a prior apply / outputs).
    parent_folder_key and parent_folder_id are mutually exclusive; key wins if both set.
  EOT
  default     = {}
}

variable "accounts" {
  type = map(object({
    display_name        = string
    folder_key          = optional(string, null)
    folder_id           = optional(string, null)
    payer_account_id    = optional(string, null)
    account_name_prefix = optional(string, null)
    tags                = optional(map(string), {})
  }))
  description = "Map of member accounts. Prefer folder_key for folders created in this module, or folder_id for existing folders. Account creation is effectively irreversible for many scenarios."
  default     = {}
}

variable "control_policies" {
  type = map(object({
    control_policy_name = string
    effect_scope        = string
    policy_document     = string
    description         = optional(string, null)
    tags                = optional(map(string), {})
  }))
  description = "Map of custom Control Policies. effect_scope is RAM or All. Enable the Control Policy feature in the console if attachments fail."
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.control_policies : contains(["RAM", "All"], v.effect_scope)
    ])
    error_message = "control_policies.*.effect_scope must be RAM or All."
  }
}

variable "control_policy_attachments" {
  type = map(object({
    policy_key         = string
    target_id          = optional(string, null)
    target_folder_key  = optional(string, null)
    target_account_key = optional(string, null)
  }))
  description = "Attach control policies to a folder or account. Provide exactly one of target_id, target_folder_key, or target_account_key."
  default     = {}
}

variable "delegated_administrators" {
  type = map(object({
    account_key       = string
    service_principal = string
  }))
  description = "Map of delegated administrator registrations (account_key from accounts + service principal)."
  default     = {}
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
  description = "Additional tags merged into ManagedBy/Module/Project/Environment"
  default     = {}
}
