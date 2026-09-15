variable "create_physical_connection" {
  type        = bool
  description = "Whether to create an Express Connect physical connection. Physical lines (including cross-border / overseas access) are often ordered offline via console or carrier; set false and pass physical_connection_id instead."
  default     = false
}

variable "physical_connection_id" {
  type        = string
  description = "Existing physical connection ID when create_physical_connection is false"
  default     = null
}

variable "access_point_id" {
  type        = string
  description = "Access point ID for a new physical connection (required when create_physical_connection is true)"
  default     = null
}

variable "line_operator" {
  type        = string
  description = "Connectivity provider: CT, CU, CM, CO (mainland other), Equinix, Other (overseas other)"
  default     = null

  validation {
    condition     = var.line_operator == null || contains(["CT", "CU", "CM", "CO", "Equinix", "Other"], var.line_operator)
    error_message = "line_operator must be one of: CT, CU, CM, CO, Equinix, Other."
  }
}

variable "physical_connection_name" {
  type        = string
  description = "Name of the physical connection"
  default     = null
}

variable "peer_location" {
  type        = string
  description = "Geographical location of the peer data center"
  default     = null
}

variable "port_type" {
  type        = string
  description = "Physical connection port type"
  default     = "1000Base-LX"

  validation {
    condition = contains([
      "100Base-T", "1000Base-T", "1000Base-LX", "10GBase-T", "10GBase-LR", "40GBase-LR", "100GBase-LR"
    ], var.port_type)
    error_message = "port_type must be a supported Express Connect port type."
  }
}

variable "bandwidth" {
  type        = number
  description = "Maximum bandwidth of the physical connection (Mbps)"
  default     = null
}

variable "circuit_code" {
  type        = string
  description = "Circuit code provided by the operator"
  default     = null
}

variable "redundant_physical_connection_id" {
  type        = string
  description = "ID of a redundant physical connection"
  default     = null
}

variable "physical_connection_description" {
  type        = string
  description = "Description of the physical connection"
  default     = null
}

variable "physical_connection_status" {
  type        = string
  description = "Physical connection status: Confirmed, Enabled, Canceled, Terminated. Enabled requires period."
  default     = null

  validation {
    condition     = var.physical_connection_status == null || contains(["Confirmed", "Enabled", "Canceled", "Terminated"], var.physical_connection_status)
    error_message = "physical_connection_status must be Confirmed, Enabled, Canceled, or Terminated."
  }
}

variable "period" {
  type        = number
  description = "Subscription duration when enabling the physical connection"
  default     = null
}

variable "pricing_cycle" {
  type        = string
  description = "Billing cycle when enabling the physical connection: Month or Year"
  default     = "Month"

  validation {
    condition     = contains(["Month", "Year"], var.pricing_cycle)
    error_message = "pricing_cycle must be Month or Year."
  }
}

variable "virtual_border_routers" {
  type = map(object({
    vlan_id                    = number
    local_gateway_ip           = string
    peer_gateway_ip            = string
    peering_subnet_mask        = string
    physical_connection_id     = optional(string, null)
    virtual_border_router_name = optional(string, null)
    description                = optional(string, null)
    bandwidth                  = optional(number, null)
    circuit_code               = optional(string, null)
    detect_multiplier          = optional(number, null)
    min_rx_interval            = optional(number, null)
    min_tx_interval            = optional(number, null)
    enable_ipv6                = optional(bool, null)
    local_ipv6_gateway_ip      = optional(string, null)
    peer_ipv6_gateway_ip       = optional(string, null)
    peering_ipv6_subnet_mask   = optional(string, null)
    mtu                        = optional(number, null)
    sitelink_enable            = optional(bool, null)
    resource_group_id          = optional(string, null)
    vbr_owner_id               = optional(string, null)
    status                     = optional(string, null)
    tags                       = optional(map(string), {})
  }))
  description = "Map of Virtual Border Routers (VBRs). Each entry requires vlan_id and peering IPs/mask. Optional per-VBR physical_connection_id overrides the module default."
  default     = {}

  validation {
    condition = alltrue([
      for v in var.virtual_border_routers : v.vlan_id >= 0 && v.vlan_id <= 2999
    ])
    error_message = "Each VBR vlan_id must be between 0 and 2999."
  }
}

variable "router_interfaces" {
  type = map(object({
    vbr_key                     = string
    router_type                 = string
    role                        = string
    spec                        = string
    opposite_region_id          = string
    opposite_router_type        = optional(string, "VRouter")
    opposite_router_id          = optional(string, null)
    opposite_interface_owner_id = optional(string, null)
    access_point_id             = optional(string, null)
    opposite_access_point_id    = optional(string, null)
    router_interface_name       = optional(string, null)
    description                 = optional(string, null)
    payment_type                = optional(string, "PayAsYouGo")
    period                      = optional(number, null)
    pricing_cycle               = optional(string, null)
    auto_renew                  = optional(bool, null)
    fast_link_mode              = optional(bool, null)
    hc_rate                     = optional(number, null)
    hc_threshold                = optional(number, null)
    health_check_source_ip      = optional(string, null)
    health_check_target_ip      = optional(string, null)
    resource_group_id           = optional(string, null)
    status                      = optional(string, null)
    tags                        = optional(map(string), {})
  }))
  description = "Optional map of Express Connect router interfaces (VBR↔VPC attachment). Prefer CEN for multi-region designs; keep this for legacy VBR-to-VPC peering."
  default     = {}

  validation {
    condition = alltrue([
      for ri in var.router_interfaces : contains(["VRouter", "VBR"], ri.router_type)
    ])
    error_message = "Each router_interfaces router_type must be VRouter or VBR."
  }

  validation {
    condition = alltrue([
      for ri in var.router_interfaces : contains(["InitiatingSide", "AcceptingSide"], ri.role)
    ])
    error_message = "Each router_interfaces role must be InitiatingSide or AcceptingSide."
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
  description = "Additional tags merged onto tagged resources (VBR, router interface)"
  default     = {}
}
