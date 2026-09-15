variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique OSS bucket name"
}
