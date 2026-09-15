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

variable "customer_gateway_ip" {
  type        = string
  description = "Public IP of the on-premises VPN device"
}

variable "local_subnet" {
  type        = list(string)
  description = "VPC CIDR blocks protected by the VPN"
  default     = ["10.0.0.0/16"]
}

variable "remote_subnet" {
  type        = list(string)
  description = "On-premises CIDR blocks"
  default     = ["192.168.0.0/16"]
}

variable "psk" {
  type        = string
  description = "IPsec pre-shared key"
  sensitive   = true
}
