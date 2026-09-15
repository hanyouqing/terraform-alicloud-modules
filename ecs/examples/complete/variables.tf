variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instances" {
  type = map(object({
    image_id                   = string
    instance_type              = string
    vswitch_id                 = string
    security_groups            = list(string)
    instance_name              = optional(string, null)
    host_name                  = optional(string, null)
    description                = optional(string, null)
    private_ip                 = optional(string, null)
    internet_max_bandwidth_out = optional(number, 0)
    internet_charge_type       = optional(string, "PayByTraffic")
    key_name                   = optional(string, null)
    password                   = optional(string, null)
    user_data                  = optional(string, null)
    deletion_protection        = optional(bool, false)
    resource_group_id          = optional(string, null)
    system_disk = optional(object({
      category             = optional(string, "cloud_essd")
      size                 = optional(number, 40)
      encrypted            = optional(bool, true)
      performance_level    = optional(string, "PL0")
      name                 = optional(string, null)
      description          = optional(string, null)
      delete_with_instance = optional(bool, true)
    }), {})
    data_disks = optional(list(object({
      name                 = optional(string, null)
      size                 = number
      category             = optional(string, "cloud_essd")
      encrypted            = optional(bool, true)
      performance_level    = optional(string, "PL0")
      delete_with_instance = optional(bool, true)
      description          = optional(string, null)
      snapshot_id          = optional(string, null)
    })), [])
    tags = optional(map(string), {})
  }))
  description = "ECS instances map. Supply image_id, vswitch_id, security_groups, and key_name (or password)."
  default     = {}
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
