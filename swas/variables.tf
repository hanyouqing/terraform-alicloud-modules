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
  description = "Map of Simple Application Server (SWAS) instances. Do not mark this map sensitive (for_each)."
  default     = {}

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Subscription"], i.payment_type)
    ])
    error_message = "payment_type must be Subscription for SWAS instances."
  }
}

variable "firewall_rules" {
  type = map(object({
    instance_key  = string
    rule_protocol = string
    port          = string
    remark        = optional(string, null)
  }))
  description = "Optional firewall rules. instance_key references keys in var.instances."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.firewall_rules : contains(["Tcp", "Udp", "TcpAndUdp"], r.rule_protocol)
    ])
    error_message = "rule_protocol must be Tcp, Udp, or TcpAndUdp."
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
  description = "Additional tags (SWAS instance resource may not accept all tags; retained for module consistency / future use)"
  default     = {}
}
