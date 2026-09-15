variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vswitch_id" {
  type        = string
  description = "vSwitch ID"
}

variable "security_group" {
  type        = string
  description = "Security group ID"
  default     = null
}
