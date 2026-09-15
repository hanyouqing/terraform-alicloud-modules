variable "instances" {
  type = map(object({
    instance_name      = optional(string, null)
    instance_type      = string
    payment_type       = string
    zone_id            = string
    auto_pay           = optional(bool, null)
    cold_storage_size  = optional(number, null)
    cpu                = optional(number, null)
    duration           = optional(number, null)
    enable_ssl         = optional(bool, null)
    gateway_count      = optional(number, null)
    initial_databases  = optional(string, null)
    leader_instance_id = optional(string, null)
    pricing_cycle      = optional(string, null)
    resource_group_id  = optional(string, null)
    scale_type         = optional(string, null)
    status             = optional(string, null)
    storage_size       = optional(number, null)
    tags               = optional(map(string), {})
    endpoints = optional(list(object({
      type       = optional(string, null)
      vpc_id     = optional(string, null)
      vswitch_id = optional(string, null)
    })), [])
  }))
  description = "Map of Hologres instances. Required per entry: instance_type, payment_type, zone_id. instance_name defaults to map key."
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
  description = "Additional tags applied to all Hologres instances"
  default     = {}
}
