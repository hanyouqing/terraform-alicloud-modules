variable "create_project" {
  type        = bool
  description = "Whether to create a DataWorks project"
  default     = true
}

variable "display_name" {
  type        = string
  description = "DataWorks project display name"
  default     = null
}

variable "project_name" {
  type        = string
  description = "DataWorks project name (unique)"
  default     = null
}

variable "pai_task_enabled" {
  type        = bool
  description = "Whether PAI tasks are enabled on the project"
  default     = false
}

variable "description" {
  type        = string
  description = "Project description"
  default     = null
}

variable "dev_environment_enabled" {
  type        = bool
  description = "Enable development environment"
  default     = null
}

variable "dev_role_disabled" {
  type        = bool
  description = "Disable default development role"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Alibaba Cloud resource group ID for the project"
  default     = null
}

variable "status" {
  type        = string
  description = "Project status when supported"
  default     = null
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
  description = "Optional DataWorks resource groups (alicloud_data_works_dw_resource_group)"
  default     = {}
}

variable "project_members" {
  type = map(object({
    user_id = string
    roles = optional(list(object({
      code = string
    })), [])
  }))
  description = "Optional project members. roles.*.code is the role code (name/type are computed by the API)."
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
  description = "Additional tags"
  default     = {}
}
