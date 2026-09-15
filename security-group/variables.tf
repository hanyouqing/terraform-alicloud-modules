variable "security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = "sg"

  validation {
    condition     = length(var.security_group_name) >= 2 && length(var.security_group_name) <= 128
    error_message = "security_group_name must be between 2 and 128 characters."
  }
}

variable "description" {
  type        = string
  description = "Description of the security group"
  default     = "Managed by terraform"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID that owns the security group"
}

variable "security_group_type" {
  type        = string
  description = "Security group type (normal or enterprise)"
  default     = "normal"

  validation {
    condition     = contains(["normal", "enterprise"], var.security_group_type)
    error_message = "security_group_type must be normal or enterprise."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "ingress_rules" {
  type = map(object({
    type                     = optional(string, "ingress")
    ip_protocol              = string
    port_range               = string
    cidr_ip                  = optional(string, null)
    source_security_group_id = optional(string, null)
    ipv6_cidr_ip             = optional(string, null)
    prefix_list_id           = optional(string, null)
    policy                   = optional(string, "accept")
    priority                 = optional(number, 1)
    description              = optional(string, null)
    nic_type                 = optional(string, "intranet")
  }))
  description = "Map of ingress rules. Default is empty (no open ingress). Provide cidr_ip or source_security_group_id (or ipv6_cidr_ip / prefix_list_id)."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "gre", "all"], lower(r.ip_protocol))
    ])
    error_message = "ingress_rules ip_protocol must be one of: tcp, udp, icmp, gre, all."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.cidr_ip != null || r.source_security_group_id != null || r.ipv6_cidr_ip != null || r.prefix_list_id != null
    ])
    error_message = "Each ingress rule requires cidr_ip, source_security_group_id, ipv6_cidr_ip, or prefix_list_id."
  }
}

variable "egress_rules" {
  type = map(object({
    type                     = optional(string, "egress")
    ip_protocol              = string
    port_range               = string
    cidr_ip                  = optional(string, null)
    source_security_group_id = optional(string, null)
    ipv6_cidr_ip             = optional(string, null)
    prefix_list_id           = optional(string, null)
    policy                   = optional(string, "accept")
    priority                 = optional(number, 1)
    description              = optional(string, null)
    nic_type                 = optional(string, "intranet")
  }))
  description = "Map of additional egress rules. Combined with allow_all_egress when that flag is true."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "gre", "all"], lower(r.ip_protocol))
    ])
    error_message = "egress_rules ip_protocol must be one of: tcp, udp, icmp, gre, all."
  }
}

variable "allow_all_egress" {
  type        = bool
  description = "When true (default), adds an egress rule allowing all outbound traffic (0.0.0.0/0, all protocols). Documented usability default; set false for locked-down egress and supply egress_rules explicitly."
  default     = true
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
  description = "Additional tags merged onto the security group"
  default     = {}
}
