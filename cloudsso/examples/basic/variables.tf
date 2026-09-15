variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "directory_id" {
  type        = string
  description = "Existing CloudSSO directory ID"
}

variable "user_name" {
  type        = string
  description = "CloudSSO user name to create"
  default     = "tf-demo"
}

variable "user_email" {
  type        = string
  description = "CloudSSO user email"
  default     = "tf-demo@example.com"
}
