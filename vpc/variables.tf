variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "vpc"

  validation {
    condition     = length(var.vpc_name) >= 2 && length(var.vpc_name) <= 128
    error_message = "vpc_name must be between 2 and 128 characters."
  }
}

variable "cidr_block" {
  type        = string
  description = "Primary IPv4 CIDR block for the VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be valid IPv4 CIDR notation."
  }
}

variable "secondary_cidr_blocks" {
  type        = list(string)
  description = "Optional secondary IPv4 CIDR blocks for the VPC"
  default     = []

  validation {
    condition     = alltrue([for c in var.secondary_cidr_blocks : can(cidrnetmask(c))])
    error_message = "All secondary_cidr_blocks must be valid IPv4 CIDR notation."
  }
}

variable "description" {
  type        = string
  description = "Description of the VPC"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID for the VPC and related resources"
  default     = null
}

variable "public_vswitches" {
  type = map(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
    description  = optional(string, null)
  }))
  description = "Map of public vswitches keyed by a stable identifier"
  default     = {}

  validation {
    condition = alltrue([
      for v in var.public_vswitches : can(cidrnetmask(v.cidr_block))
    ])
    error_message = "Each public_vswitches cidr_block must be valid IPv4 CIDR notation."
  }
}

variable "private_vswitches" {
  type = map(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
    description  = optional(string, null)
  }))
  description = "Map of private vswitches keyed by a stable identifier"
  default     = {}

  validation {
    condition = alltrue([
      for v in var.private_vswitches : can(cidrnetmask(v.cidr_block))
    ])
    error_message = "Each private_vswitches cidr_block must be valid IPv4 CIDR notation."
  }
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT Gateway, EIP, association, and SNAT entries for private vswitches"
  default     = false
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT Gateway"
  default     = "nat-gateway"
}

variable "nat_gateway_specification" {
  type        = string
  description = "NAT Gateway specification (Small, Middle, Large, XLarge.1)"
  default     = "Small"

  validation {
    condition     = contains(["Small", "Middle", "Large", "XLarge.1"], var.nat_gateway_specification)
    error_message = "nat_gateway_specification must be one of: Small, Middle, Large, XLarge.1."
  }
}

variable "nat_vswitch_key" {
  type        = string
  description = "Key of the public vswitch used to host the Enhanced NAT Gateway. Defaults to the first public vswitch key when create_nat_gateway is true."
  default     = null
}

variable "eip_bandwidth" {
  type        = number
  description = "EIP bandwidth in Mbps for the NAT Gateway"
  default     = 5

  validation {
    condition     = var.eip_bandwidth >= 1 && var.eip_bandwidth <= 200
    error_message = "eip_bandwidth must be between 1 and 200 Mbps."
  }
}

variable "eip_internet_charge_type" {
  type        = string
  description = "EIP internet charge type (PayByBandwidth or PayByTraffic)"
  default     = "PayByTraffic"

  validation {
    condition     = contains(["PayByBandwidth", "PayByTraffic"], var.eip_internet_charge_type)
    error_message = "eip_internet_charge_type must be PayByBandwidth or PayByTraffic."
  }
}

variable "create_public_route_tables" {
  type        = bool
  description = "Whether to create custom route tables for public vswitches (false uses the VPC system route table)"
  default     = false
}

variable "create_private_route_tables" {
  type        = bool
  description = "Whether to create custom route tables for private vswitches with 0.0.0.0/0 pointing to the NAT Gateway when create_nat_gateway is true"
  default     = false
}

variable "enable_flow_log" {
  type        = bool
  description = "Whether to create a VPC flow log delivering to an existing SLS project/logstore"
  default     = false
}

variable "flow_log_name" {
  type        = string
  description = "Name of the VPC flow log"
  default     = "vpc-flow-log"
}

variable "flow_log_project" {
  type        = string
  description = "SLS project name for VPC flow logs (required when enable_flow_log is true)"
  default     = null
}

variable "flow_log_logstore" {
  type        = string
  description = "SLS logstore name for VPC flow logs (required when enable_flow_log is true)"
  default     = null
}

variable "flow_log_traffic_type" {
  type        = string
  description = "Traffic type captured by the flow log (All, Allow, or Drop)"
  default     = "All"

  validation {
    condition     = contains(["All", "Allow", "Drop"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type must be All, Allow, or Drop."
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
