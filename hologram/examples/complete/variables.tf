variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

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
  description = "Production-oriented Hologres instances (SSL + VPC endpoints)"
  default = {
    warehouse = {
      instance_type = "Standard"
      payment_type  = "PostPaid"
      zone_id       = "cn-hangzhou-h"
      cpu           = 16
      storage_size  = 80
      enable_ssl    = true
      endpoints = [{
        type       = "VPCSingleTunnel"
        vpc_id     = "vpc-xxxxxxxx"
        vswitch_id = "vsw-xxxxxxxx"
      }]
    }
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
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
