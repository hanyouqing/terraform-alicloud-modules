variable "load_balancer_name" {
  type        = string
  description = "Name of the Network Load Balancer"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the NLB is deployed"
}

variable "address_type" {
  type        = string
  description = "NLB address type: Internet or Intranet"
  default     = "Intranet"

  validation {
    condition     = contains(["Internet", "Intranet"], var.address_type)
    error_message = "address_type must be Internet or Intranet."
  }
}

variable "address_ip_version" {
  type        = string
  description = "IP version: Ipv4 or DualStack"
  default     = "Ipv4"

  validation {
    condition     = contains(["Ipv4", "DualStack"], var.address_ip_version)
    error_message = "address_ip_version must be Ipv4 or DualStack."
  }
}

variable "cross_zone_enabled" {
  type        = bool
  description = "Whether to enable cross-zone load balancing"
  default     = true
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Optional security group IDs attached to the NLB"
  default     = []
}

variable "zone_mappings" {
  type = list(object({
    zone_id              = string
    vswitch_id           = string
    private_ipv4_address = optional(string, null)
    allocation_id        = optional(string, null)
  }))
  description = "At least two zone mappings (zone_id + vswitch_id) for multi-AZ NLB"

  validation {
    condition     = length(var.zone_mappings) >= 2
    error_message = "zone_mappings must include at least two zones."
  }
}

variable "server_groups" {
  type = map(object({
    server_group_name        = optional(string, null)
    server_group_type        = optional(string, "Instance")
    protocol                 = optional(string, "TCP")
    scheduler                = optional(string, "Wrr")
    address_ip_version       = optional(string, "Ipv4")
    connection_drain_enabled = optional(bool, false)
    connection_drain_timeout = optional(number, 60)
    health_check = optional(object({
      health_check_enabled         = optional(bool, true)
      health_check_type            = optional(string, "TCP")
      health_check_connect_port    = optional(number, 0)
      healthy_threshold            = optional(number, 2)
      unhealthy_threshold          = optional(number, 2)
      health_check_connect_timeout = optional(number, 5)
      health_check_interval        = optional(number, 10)
      health_check_domain          = optional(string, null)
      health_check_url             = optional(string, null)
      http_check_method            = optional(string, null)
      health_check_http_code       = optional(list(string), null)
    }), {})
    servers = optional(list(object({
      server_id   = string
      server_type = optional(string, "Ecs")
      port        = number
      weight      = optional(number, 100)
      server_ip   = optional(string, null)
      description = optional(string, null)
    })), [])
  }))
  description = "Map of NLB server groups with optional backend server attachments"
  default     = {}

  validation {
    condition = alltrue([
      for sg in var.server_groups : contains(["TCP", "UDP", "TCPSSL"], sg.protocol)
    ])
    error_message = "Each server_groups protocol must be TCP, UDP, or TCPSSL."
  }
}

variable "listeners" {
  type = map(object({
    listener_protocol      = string
    listener_port          = number
    server_group_key       = string
    description            = optional(string, null)
    idle_timeout           = optional(number, 900)
    proxy_protocol_enabled = optional(bool, false)
    cps                    = optional(number, null)
    mss                    = optional(number, null)
    certificate_ids        = optional(list(string), null)
    ca_enabled             = optional(bool, null)
    ca_certificate_ids     = optional(list(string), null)
    security_policy_id     = optional(string, null)
    alpn_enabled           = optional(bool, null)
    alpn_policy            = optional(string, null)
  }))
  description = "Map of NLB listeners (TCP / UDP / TCPSSL). TCPSSL requires certificate_ids."
  default     = {}

  validation {
    condition = alltrue([
      for l in var.listeners : contains(["TCP", "UDP", "TCPSSL"], l.listener_protocol)
    ])
    error_message = "Each listeners listener_protocol must be TCP, UDP, or TCPSSL."
  }

  validation {
    condition = alltrue([
      for l in var.listeners : l.listener_protocol != "TCPSSL" || (l.certificate_ids != null && length(l.certificate_ids) > 0)
    ])
    error_message = "TCPSSL listeners require certificate_ids."
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
  description = "Additional tags merged onto all tagged resources"
  default     = {}
}
