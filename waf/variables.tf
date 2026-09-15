variable "create_instance" {
  type        = bool
  description = "Whether to create a paid WAFv3 instance. Prefer false and pass instance_id for most environments."
  default     = false
}

variable "instance_id" {
  type        = string
  description = "Existing WAFv3 instance ID when create_instance is false"
  default     = null
}

variable "domains" {
  type = map(object({
    domain                             = optional(string, null)
    access_type                        = optional(string, "share")
    resource_manager_resource_group_id = optional(string, null)
    listen = object({
      http_ports          = optional(list(number), [80])
      https_ports         = optional(list(number), [])
      cert_id             = optional(string, null)
      tls_version         = optional(string, null)
      enable_tlsv3        = optional(bool, null)
      http2_enabled       = optional(bool, null)
      ipv6_enabled        = optional(bool, false)
      exclusive_ip        = optional(bool, false)
      focus_https         = optional(bool, null)
      protection_resource = optional(string, "share")
      cipher_suite        = optional(number, null)
      custom_ciphers      = optional(list(string), null)
      xff_header_mode     = optional(number, null)
      xff_headers         = optional(list(string), null)
    })
    redirect = object({
      backends           = list(string)
      loadbalance        = optional(string, "iphash")
      connect_timeout    = optional(number, 5)
      read_timeout       = optional(number, 120)
      write_timeout      = optional(number, 120)
      keepalive          = optional(bool, true)
      retry              = optional(bool, true)
      sni_enabled        = optional(bool, null)
      sni_host           = optional(string, null)
      focus_http_backend = optional(bool, null)
      keepalive_requests = optional(number, null)
      keepalive_timeout  = optional(number, null)
      request_headers = optional(list(object({
        key   = string
        value = string
      })), [])
    })
  }))
  description = "Map of WAFv3 protected domains with listen ports and redirect backends"
  default     = {}

  validation {
    condition = alltrue([
      for d in var.domains : contains(["share"], d.access_type)
    ])
    error_message = "Each domains access_type must be share (CNAME mode)."
  }

  validation {
    condition = alltrue([
      for d in var.domains : contains(["iphash", "roundRobin", "leastTime"], d.redirect.loadbalance)
    ])
    error_message = "Each redirect.loadbalance must be iphash, roundRobin, or leastTime."
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
