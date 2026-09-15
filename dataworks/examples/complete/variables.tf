variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_project" {
  type        = bool
  description = "Whether to create the project"
  default     = true
}

variable "display_name" {
  type        = string
  description = "Project display name"
  default     = "Prod DataWorks"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "prod_dataworks"
}

variable "pai_task_enabled" {
  type        = bool
  description = "Enable PAI tasks"
  default     = true
}

variable "description" {
  type        = string
  description = "Project description"
  default     = "production data development"
}

variable "dev_environment_enabled" {
  type        = bool
  description = "Enable development environment"
  default     = true
}

variable "dw_resource_groups" {
  type = map(object({
    default_vpc_id        = string
    default_vswitch_id    = string
    remark                = string
    resource_group_name   = optional(string, null)
    payment_type          = optional(string, null)
    payment_duration      = optional(number, null)
    payment_duration_unit = optional(string, null)
    auto_renew            = optional(bool, null)
    specification         = optional(number, null)
    resource_group_id     = optional(string, null)
    tags                  = optional(map(string), {})
  }))
  description = "Optional DW resource groups"
  default     = {}
}

variable "project_members" {
  type = map(object({
    user_id = string
    roles = optional(list(object({
      code = string
    })), [])
  }))
  description = "Optional project members (roles.*.code only; name/type are computed)"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
