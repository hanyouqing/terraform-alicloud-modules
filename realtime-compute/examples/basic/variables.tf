variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vvp_instance_name" {
  type        = string
  description = "VVP instance name"
  default     = "demo-flink"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vswitch_ids" {
  type        = list(string)
  description = "vSwitch IDs"
}

variable "zone_id" {
  type        = string
  description = "Zone ID"
}

variable "oss_bucket" {
  type        = string
  description = "OSS bucket for Flink storage"
}
