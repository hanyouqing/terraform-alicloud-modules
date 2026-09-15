variable "trails" {
  type = map(object({
    trail_name            = optional(string, null)
    oss_bucket_name       = optional(string, null)
    oss_key_prefix        = optional(string, null)
    oss_write_role_arn    = optional(string, null)
    sls_project_arn       = optional(string, null)
    sls_write_role_arn    = optional(string, null)
    event_rw              = optional(string, "All")
    trail_region          = optional(string, null)
    status                = optional(string, "Enable")
    is_organization_trail = optional(bool, false)
  }))
  description = "Map of ActionTrail trails. Prefer OSS delivery for Landing Zone audit/log account patterns. At least one of oss_bucket_name or sls_project_arn is required per trail."
  default     = {}

  validation {
    condition = alltrue([
      for t in values(var.trails) : contains(["Read", "Write", "All"], t.event_rw)
    ])
    error_message = "Each trails.event_rw must be Read, Write, or All."
  }

  validation {
    condition = alltrue([
      for t in values(var.trails) : contains(["Enable", "Disable"], t.status)
    ])
    error_message = "Each trails.status must be Enable or Disable."
  }

  validation {
    condition = alltrue([
      for t in values(var.trails) : (
        (t.oss_bucket_name != null && t.oss_bucket_name != "") ||
        (t.sls_project_arn != null && t.sls_project_arn != "")
      )
    ])
    error_message = "Each trail must set oss_bucket_name and/or sls_project_arn."
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
  description = "Additional tags (retained for convention; ActionTrail may not accept resource tags on all versions)"
  default     = {}
}
