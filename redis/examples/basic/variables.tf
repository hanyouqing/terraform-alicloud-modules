variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vswitch_id" {
  type        = string
  description = "Private vSwitch ID"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used as default security_ips"
  default     = "10.0.0.0/16"
}

variable "instance_class" {
  type        = string
  description = "Redis instance class"
  default     = "redis.master.small.default"
}

variable "password" {
  type        = string
  description = "Redis password"
  sensitive   = true
}
