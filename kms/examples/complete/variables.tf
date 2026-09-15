variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "alias_name" {
  type        = string
  description = "KMS alias name"
  default     = "alias/app-cmk"
}

variable "app_secret" {
  type        = string
  description = "Secret payload stored in KMS Secrets Manager"
  sensitive   = true
}
