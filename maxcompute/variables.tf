variable "projects" {
  type = map(object({
    project_name     = optional(string, null)
    comment          = optional(string, null)
    default_quota    = optional(string, null)
    product_type     = optional(string, null)
    is_logical       = optional(string, null)
    status           = optional(string, null)
    three_tier_model = optional(bool, null)
    tags             = optional(map(string), {})
    ip_white_list = optional(object({
      ip_list     = optional(string, null)
      vpc_ip_list = optional(string, null)
    }), null)
    security_properties = optional(object({
      enable_download_privilege            = optional(bool, null)
      label_security                       = optional(bool, null)
      object_creator_has_access_permission = optional(bool, null)
      object_creator_has_grant_permission  = optional(bool, null)
      using_acl                            = optional(bool, null)
      using_policy                         = optional(bool, null)
      project_protection = optional(object({
        exception_policy = optional(string, null)
        protected        = optional(bool, null)
      }), null)
    }), null)
    properties = optional(object({
      allow_full_scan  = optional(bool, null)
      enable_decimal2  = optional(bool, null)
      enable_dr        = optional(bool, null)
      retention_days   = optional(number, null)
      sql_metering_max = optional(string, null)
      timezone         = optional(string, null)
      type_system      = optional(string, null)
      encryption = optional(object({
        algorithm = optional(string, null)
        enable    = optional(bool, null)
        key       = optional(string, null)
      }), null)
      table_lifecycle = optional(object({
        type  = optional(string, null)
        value = optional(string, null)
      }), null)
    }), null)
  }))
  description = "Map of MaxCompute projects (alicloud_maxcompute_project). project_name defaults to map key."
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
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to all MaxCompute projects"
  default     = {}
}
