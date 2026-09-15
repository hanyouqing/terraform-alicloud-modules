variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "vswitch_id" {
  type        = string
  description = "vSwitch ID for the VPN gateway"
  default     = null
}

variable "bandwidth" {
  type        = number
  description = "VPN gateway bandwidth in Mbps"
  default     = 20
}

variable "local_subnet" {
  type        = list(string)
  description = "VPC CIDR blocks protected by the VPN"
  default     = ["10.0.0.0/16"]
}

variable "hq_customer_gateway_ip" {
  type        = string
  description = "HQ on-premises public IP"
}

variable "dr_customer_gateway_ip" {
  type        = string
  description = "DR on-premises public IP"
}

variable "hq_asn" {
  type        = number
  description = "Optional ASN for HQ customer gateway"
  default     = null
}

variable "hq_remote_subnet" {
  type        = list(string)
  description = "HQ on-premises CIDRs"
  default     = ["192.168.0.0/16"]
}

variable "dr_remote_subnet" {
  type        = list(string)
  description = "DR on-premises CIDRs"
  default     = ["172.16.0.0/16"]
}

variable "hq_psk" {
  type        = string
  description = "HQ IPsec pre-shared key"
  sensitive   = true
}

variable "dr_psk" {
  type        = string
  description = "DR IPsec pre-shared key"
  sensitive   = true
}
