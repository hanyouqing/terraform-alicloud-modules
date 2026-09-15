variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "bucket_name" {
  type        = string
  description = "OSS bucket name referenced by the sample policy"
  default     = "example-bucket"
}
