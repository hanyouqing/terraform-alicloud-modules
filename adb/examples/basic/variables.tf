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
  description = "Private vSwitch ID"
}

variable "zone_id" {
  type        = string
  description = "Availability zone ID"
  default     = "cn-hangzhou-h"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used as security_ips"
  default     = "10.0.0.0/16"
}

variable "db_cluster_version" {
  type        = string
  description = "ADB lake cluster version"
  default     = "5.0"
}

variable "compute_resource" {
  type        = string
  description = "Compute resource (ACU)"
  default     = "16ACU"
}

variable "storage_resource" {
  type        = string
  description = "Storage resource (ACU)"
  default     = "0ACU"
}
