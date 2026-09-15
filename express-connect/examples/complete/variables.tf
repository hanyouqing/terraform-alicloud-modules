variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_physical_connection" {
  type        = bool
  description = "Create physical connection (usually false; lines are ordered offline)"
  default     = false
}

variable "physical_connection_id" {
  type        = string
  description = "Existing physical connection ID"
  default     = null
}

variable "access_point_id" {
  type        = string
  description = "Access point ID when creating a physical connection"
  default     = null
}

variable "line_operator" {
  type        = string
  description = "Line operator when creating a physical connection"
  default     = null
}

variable "physical_connection_name" {
  type        = string
  description = "Physical connection name"
  default     = "complete-pconn"
}

variable "peer_location" {
  type        = string
  description = "Peer data center location"
  default     = null
}

variable "port_type" {
  type        = string
  description = "Port type"
  default     = "1000Base-LX"
}

variable "bandwidth" {
  type        = number
  description = "Physical connection bandwidth Mbps"
  default     = 100
}

variable "physical_connection_description" {
  type        = string
  description = "Physical connection description"
  default     = "complete example physical connection"
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
    detect_multiplier          = optional(number, null)
    min_rx_interval            = optional(number, null)
    min_tx_interval            = optional(number, null)
    tags                       = optional(map(string), {})
  }))
  description = "VBRs to create"
  default = {
    vbr-primary = {
      vlan_id                    = 1001
      local_gateway_ip           = "10.0.0.1"
      peer_gateway_ip            = "10.0.0.2"
      peering_subnet_mask        = "255.255.255.252"
      virtual_border_router_name = "complete-vbr-primary"
      detect_multiplier          = 10
      min_rx_interval            = 1000
      min_tx_interval            = 1000
    }
    vbr-secondary = {
      vlan_id                    = 1002
      local_gateway_ip           = "10.0.1.1"
      peer_gateway_ip            = "10.0.1.2"
      peering_subnet_mask        = "255.255.255.252"
      virtual_border_router_name = "complete-vbr-secondary"
    }
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
    router_interface_name       = optional(string, null)
    payment_type                = optional(string, "PayAsYouGo")
    fast_link_mode              = optional(bool, null)
    tags                        = optional(map(string), {})
  }))
  description = "Optional router interfaces (leave empty unless attaching VBR to a VPC router)"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
