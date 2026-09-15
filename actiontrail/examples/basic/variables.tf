variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "oss_bucket_name" {
  type        = string
  description = "Existing OSS bucket for ActionTrail delivery"
}

variable "oss_write_role_arn" {
  type        = string
  description = "Optional RAM role ARN ActionTrail assumes to write to OSS"
  default     = null
}
