variable "load_balancer_name" {
  type        = string
  description = "Name of the Application Load Balancer"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB is deployed"
}

variable "address_type" {
  type        = string
  description = "ALB address type: Internet or Intranet"
  default     = "Internet"

  validation {
    condition     = contains(["Internet", "Intranet"], var.address_type)
    error_message = "address_type must be Internet or Intranet."
  }
}

variable "address_allocated_mode" {
  type        = string
  description = "IP allocation mode for the ALB (Fixed or Dynamic)"
  default     = "Fixed"

  validation {
    condition     = contains(["Fixed", "Dynamic"], var.address_allocated_mode)
    error_message = "address_allocated_mode must be Fixed or Dynamic."
  }
}

variable "load_balancer_edition" {
  type        = string
  description = "ALB edition: Basic or Standard"
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard"], var.load_balancer_edition)
    error_message = "load_balancer_edition must be Basic or Standard."
  }
}

variable "pay_type" {
  type        = string
  description = "Billing method for the ALB"
  default     = "PayAsYouGo"

  validation {
    condition     = contains(["PayAsYouGo"], var.pay_type)
    error_message = "pay_type must be PayAsYouGo."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "zone_mappings" {
  type = list(object({
    zone_id    = string
    vswitch_id = string
  }))
  description = "At least two zone mappings (zone_id + vswitch_id) for multi-AZ ALB"

  validation {
    condition     = length(var.zone_mappings) >= 2
    error_message = "zone_mappings must include at least two zones."
  }
}

variable "server_groups" {
  type = map(object({
    server_group_name = optional(string, null)
    protocol          = optional(string, "HTTP")
    scheduler         = optional(string, "Wrr")
    server_group_type = optional(string, "Instance")
    sticky_session = optional(object({
      sticky_session_enabled = optional(bool, false)
      sticky_session_type    = optional(string, "Insert")
      cookie                 = optional(string, null)
      cookie_timeout         = optional(number, 1000)
    }), {})
    health_check = optional(object({
      health_check_enabled      = optional(bool, true)
      health_check_protocol     = optional(string, "HTTP")
      health_check_path         = optional(string, "/")
      health_check_method       = optional(string, "HEAD")
      health_check_http_version = optional(string, "HTTP1.1")
      health_check_codes        = optional(list(string), ["http_2xx", "http_3xx"])
      health_check_interval     = optional(number, 2)
      health_check_timeout      = optional(number, 5)
      healthy_threshold         = optional(number, 3)
      unhealthy_threshold       = optional(number, 3)
      health_check_connect_port = optional(number, null)
      health_check_host         = optional(string, null)
    }), {})
    servers = optional(list(object({
      server_id   = string
      server_type = optional(string, "Ecs")
      port        = number
      weight      = optional(number, 100)
      description = optional(string, null)
      server_ip   = optional(string, null)
    })), [])
  }))
  description = "Map of ALB server groups with health checks and optional backend servers"
  default     = {}

  validation {
    condition = alltrue([
      for sg in var.server_groups : contains(["HTTP", "HTTPS", "gRPC"], sg.protocol)
    ])
    error_message = "Each server_groups protocol must be HTTP, HTTPS, or gRPC."
  }
}

variable "listeners" {
  type = map(object({
    listener_protocol  = string
    listener_port      = number
    server_group_key   = string
    certificate_id     = optional(string, null)
    gzip_enabled       = optional(bool, true)
    http2_enabled      = optional(bool, true)
    idle_timeout       = optional(number, 15)
    request_timeout    = optional(number, 60)
    security_policy_id = optional(string, null)
    description        = optional(string, null)
  }))
  description = "Map of ALB listeners. HTTPS listeners require certificate_id."
  default     = {}

  validation {
    condition = alltrue([
      for l in var.listeners : contains(["HTTP", "HTTPS", "QUIC"], l.listener_protocol)
    ])
    error_message = "Each listeners listener_protocol must be HTTP, HTTPS, or QUIC."
  }

  validation {
    condition = alltrue([
      for l in var.listeners : l.listener_protocol != "HTTPS" || l.certificate_id != null
    ])
    error_message = "HTTPS listeners require certificate_id."
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
