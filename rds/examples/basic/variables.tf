variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vswitch_id" {
  type        = string
  description = "Private vSwitch ID for the RDS instance"
}

variable "zone_id" {
  type        = string
  description = "Primary zone ID"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used as default security_ips"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  type        = string
  description = "RDS instance class"
  default     = "mysql.n2.medium.1"
}
