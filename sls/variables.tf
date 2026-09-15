variable "project_name" {
  type        = string
  description = "SLS project name (globally unique within the region)"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.project_name)) || can(regex("^[a-z0-9]{1,63}$", var.project_name))
    error_message = "project_name must be a valid SLS project name (lowercase letters, digits, hyphens)."
  }
}

variable "description" {
  type        = string
  description = "Description of the SLS project"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID for the SLS project"
  default     = null
}

variable "log_stores" {
  type = map(object({
    logstore_name         = optional(string, null)
    retention_period      = optional(number, 30)
    shard_count           = optional(number, 2)
    auto_split            = optional(bool, true)
    max_split_shard_count = optional(number, 64)
    append_meta           = optional(bool, true)
    enable_web_tracking   = optional(bool, false)
    create_index          = optional(bool, false)
    full_text = optional(object({
      case_sensitive  = optional(bool, false)
      include_chinese = optional(bool, false)
      token           = optional(string, ", '\";=()[]{}?@&<>/:\\n\\t\\r")
    }), null)
    field_search = optional(list(object({
      name             = string
      type             = optional(string, "text")
      alias            = optional(string, null)
      case_sensitive   = optional(bool, false)
      include_chinese  = optional(bool, false)
      token            = optional(string, ", '\";=()[]{}?@&<>/:\\n\\t\\r")
      enable_analytics = optional(bool, true)
    })), [])
  }))
  description = "Map of log stores. Set create_index=true to create an optional index."
  default     = {}

  validation {
    condition = alltrue([
      for s in var.log_stores : s.retention_period >= 1 && s.retention_period <= 3650
    ])
    error_message = "Each log_stores retention_period must be between 1 and 3650 days."
  }

  validation {
    condition = alltrue([
      for s in var.log_stores : s.shard_count >= 1 && s.shard_count <= 10
    ])
    error_message = "Each log_stores shard_count must be between 1 and 10."
  }
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags merged onto all tagged resources"
  default     = {}
}
