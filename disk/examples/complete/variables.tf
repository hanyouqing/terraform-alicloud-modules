variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "demo"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "disks" {
  type = map(object({
    disk_name               = string
    zone_id                 = string
    size                    = number
    category                = optional(string, "cloud_essd")
    performance_level       = optional(string, "PL1")
    encrypted               = optional(bool, true)
    kms_key_id              = optional(string, null)
    description             = optional(string, null)
    payment_type            = optional(string, "PayAsYouGo")
    delete_auto_snapshot    = optional(bool, false)
    delete_with_instance    = optional(bool, false)
    auto_snapshot_policy_id = optional(string, null)
    tags                    = optional(map(string), {})
  }))
  description = "Disks to create"
  default     = {}
}

variable "attachments" {
  type = map(object({
    disk_key             = string
    instance_id          = string
    delete_with_instance = optional(bool, false)
  }))
  description = "Optional attachments"
  default     = {}
}

variable "snapshot_policies" {
  type = map(object({
    name            = string
    repeat_weekdays = list(string)
    time_points     = list(string)
    retention_days  = optional(number, 7)
    tags            = optional(map(string), {})
  }))
  description = "Optional snapshot policies"
  default     = {}
}

variable "snapshot_policy_attachments" {
  type = map(object({
    disk_key            = string
    snapshot_policy_key = string
  }))
  description = "Optional snapshot policy attachments"
  default     = {}
}
