variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "cen_instance_name" {
  type        = string
  description = "CEN instance name"
  default     = "basic-cen"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to attach"
}
