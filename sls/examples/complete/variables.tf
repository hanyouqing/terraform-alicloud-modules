variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "project_name" {
  type        = string
  description = "SLS project name (must be unique)"
  default     = "tf-alicloud-sls-complete"
}
