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
  description = "Map of ECS instances to create. internet_max_bandwidth_out defaults to 0 (no public IP). system_disk defaults to encrypted cloud_essd."

  validation {
    condition = alltrue([
      for i in var.instances : i.internet_max_bandwidth_out >= 0 && i.internet_max_bandwidth_out <= 100
    ])
    error_message = "internet_max_bandwidth_out must be between 0 and 100."
  }

  validation {
    condition = alltrue([
      for i in var.instances : length(i.security_groups) > 0
    ])
    error_message = "Each instance requires at least one security group."
  }

  validation {
    condition = alltrue([
      for i in var.instances : i.key_name != null || i.password != null
    ])
    error_message = "Each instance requires key_name or password."
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
  description = "Additional tags merged onto all instances"
  default     = {}
}
