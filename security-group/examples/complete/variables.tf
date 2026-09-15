variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "security_group_name" {
  type        = string
  description = "Security group name"
  default     = "complete-sg"
}

variable "description" {
  type        = string
  description = "Security group description"
  default     = "Complete security group example"
}

variable "security_group_type" {
  type        = string
  description = "Security group type"
  default     = "normal"
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
  description = "Ingress rules"
  default = {
    https = {
      ip_protocol = "tcp"
      port_range  = "443/443"
      cidr_ip     = "0.0.0.0/0"
      priority    = 1
      description = "HTTPS"
    }
    ssh = {
      ip_protocol = "tcp"
      port_range  = "22/22"
      cidr_ip     = "10.0.0.0/8"
      priority    = 10
      description = "SSH from private networks"
    }
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
  description = "Additional egress rules"
  default     = {}
}

variable "allow_all_egress" {
  type        = bool
  description = "Allow all outbound traffic"
  default     = true
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
