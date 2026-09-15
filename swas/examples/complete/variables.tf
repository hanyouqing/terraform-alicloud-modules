variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instances" {
  type = map(object({
    image_id       = string
    plan_id        = string
    instance_name  = optional(string, null)
    payment_type   = optional(string, "Subscription")
    period         = optional(number, 1)
    data_disk_size = optional(number, null)
    password       = optional(string, null)
  }))
  description = "SWAS instances"
  default     = {}
}

variable "firewall_rules" {
  type = map(object({
    instance_key  = string
    rule_protocol = string
    port          = string
    remark        = optional(string, null)
  }))
  description = "Firewall rules"
  default     = {}
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
