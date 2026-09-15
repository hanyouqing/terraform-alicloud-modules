variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "zone_id" {
  type        = string
  description = "Availability zone for the public vswitch"
  default     = "cn-hangzhou-i"
}
