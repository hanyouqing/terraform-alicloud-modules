variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "physical_connection_id" {
  type        = string
  description = "Existing Express Connect physical connection ID"
}

variable "vlan_id" {
  type        = number
  description = "VLAN ID for the VBR (0-2999)"
  default     = 1001
}

variable "local_gateway_ip" {
  type        = string
  description = "Alibaba Cloud side peering IP"
  default     = "10.0.0.1"
}

variable "peer_gateway_ip" {
  type        = string
  description = "Customer side peering IP"
  default     = "10.0.0.2"
}

variable "peering_subnet_mask" {
  type        = string
  description = "Peering subnet mask"
  default     = "255.255.255.252"
}
