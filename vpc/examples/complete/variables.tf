variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "complete-vpc"
}

variable "cidr_block" {
  type        = string
  description = "Primary VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "secondary_cidr_blocks" {
  type        = list(string)
  description = "Secondary VPC CIDRs"
  default     = []
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "public_vswitches" {
  type = map(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
    description  = optional(string, null)
  }))
  description = "Public vswitches"
  default = {
    public-a = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "public-a"
    }
    public-b = {
      zone_id      = "cn-hangzhou-j"
      cidr_block   = "10.0.2.0/24"
      vswitch_name = "public-b"
    }
  }
}

variable "private_vswitches" {
  type = map(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
    description  = optional(string, null)
  }))
  description = "Private vswitches"
  default = {
    private-a = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.11.0/24"
      vswitch_name = "private-a"
    }
    private-b = {
      zone_id      = "cn-hangzhou-j"
      cidr_block   = "10.0.12.0/24"
      vswitch_name = "private-b"
    }
  }
}

variable "create_nat_gateway" {
  type        = bool
  description = "Create NAT Gateway + EIP + SNAT"
  default     = true
}

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway name"
  default     = "complete-nat"
}

variable "nat_gateway_specification" {
  type        = string
  description = "NAT Gateway specification"
  default     = "Small"
}

variable "nat_vswitch_key" {
  type        = string
  description = "Public vswitch key for Enhanced NAT"
  default     = "public-a"
}

variable "eip_bandwidth" {
  type        = number
  description = "EIP bandwidth Mbps"
  default     = 5
}

variable "create_public_route_tables" {
  type        = bool
  description = "Create custom public route tables"
  default     = false
}

variable "create_private_route_tables" {
  type        = bool
  description = "Create custom private route tables with default route to NAT"
  default     = true
}

variable "enable_flow_log" {
  type        = bool
  description = "Enable VPC flow log to SLS"
  default     = false
}

variable "flow_log_name" {
  type        = string
  description = "Flow log name"
  default     = "complete-vpc-flow-log"
}

variable "flow_log_project" {
  type        = string
  description = "Existing SLS project name"
  default     = null
}

variable "flow_log_logstore" {
  type        = string
  description = "Existing SLS logstore name"
  default     = null
}

variable "flow_log_traffic_type" {
  type        = string
  description = "Flow log traffic type"
  default     = "All"
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
