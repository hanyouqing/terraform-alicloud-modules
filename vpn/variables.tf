variable "vpn_gateway_name" {
  type        = string
  description = "Name of the VPN gateway"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID attached to the VPN gateway"
}

variable "vswitch_id" {
  type        = string
  description = "vSwitch ID for the VPN gateway (required for dual-tunnel / newer gateways)"
  default     = null
}

variable "bandwidth" {
  type        = number
  description = "VPN gateway bandwidth in Mbps (5, 10, 20, 50, 100, 200, 500, 1000)"
  default     = 10

  validation {
    condition     = contains([5, 10, 20, 50, 100, 200, 500, 1000], var.bandwidth)
    error_message = "bandwidth must be one of: 5, 10, 20, 50, 100, 200, 500, 1000."
  }
}

variable "enable_ipsec" {
  type        = bool
  description = "Whether to enable IPsec-VPN"
  default     = true
}

variable "enable_ssl" {
  type        = bool
  description = "Whether to enable SSL-VPN"
  default     = false
}

variable "ssl_connections" {
  type        = number
  description = "Maximum SSL-VPN concurrent connections when enable_ssl is true"
  default     = 5
}

variable "network_type" {
  type        = string
  description = "Network type of the VPN gateway: public or private"
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.network_type)
    error_message = "network_type must be public or private."
  }
}

variable "payment_type" {
  type        = string
  description = "Payment type for the VPN gateway"
  default     = "PayAsYouGo"
}

variable "auto_propagate" {
  type        = bool
  description = "Whether to automatically advertise VPN routes to the VPC"
  default     = true
}

variable "description" {
  type        = string
  description = "Description of the VPN gateway"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "customer_gateways" {
  type = map(object({
    name        = optional(string, null)
    ip_address  = string
    asn         = optional(number, null)
    description = optional(string, null)
  }))
  description = "Map of customer (on-premises) gateways"
  default     = {}

  validation {
    condition = alltrue([
      for cgw in var.customer_gateways : can(regex("^\\d{1,3}(\\.\\d{1,3}){3}$", cgw.ip_address))
    ])
    error_message = "Each customer_gateways ip_address must be a valid IPv4 address."
  }
}

variable "connections" {
  type = map(object({
    name                 = optional(string, null)
    customer_gateway_key = string
    local_subnet         = list(string)
    remote_subnet        = list(string)
    effect_immediately   = optional(bool, true)
    enable_dpd           = optional(bool, true)
    enable_nat_traversal = optional(bool, true)
    ike_config = optional(object({
      psk          = string
      ike_version  = optional(string, "ikev2")
      ike_mode     = optional(string, "main")
      ike_enc_alg  = optional(string, "aes256")
      ike_auth_alg = optional(string, "sha256")
      ike_pfs      = optional(string, "group14")
      ike_lifetime = optional(number, 86400)
      local_id     = optional(string, null)
      remote_id    = optional(string, null)
    }), null)
    ipsec_config = optional(object({
      ipsec_enc_alg  = optional(string, "aes256")
      ipsec_auth_alg = optional(string, "sha256")
      ipsec_pfs      = optional(string, "group14")
      ipsec_lifetime = optional(number, 86400)
    }), null)
  }))
  description = "Map of IPsec connections. Treat ike_config.psk as confidential."
  default     = {}

  validation {
    condition = alltrue([
      for c in var.connections : length(c.local_subnet) >= 1 && length(c.remote_subnet) >= 1
    ])
    error_message = "Each connection must define at least one local_subnet and remote_subnet."
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
