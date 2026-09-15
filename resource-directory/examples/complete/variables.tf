variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_resource_directory" {
  type        = bool
  description = "Create Resource Directory (only if not already enabled on the master account)"
  default     = false
}

variable "member_display_name" {
  type        = string
  description = "Display name for the member account (creation is hard to reverse)"
  default     = "tf-prod-workload"
}

variable "account_name_prefix" {
  type        = string
  description = "Optional account name prefix for the member account"
  default     = null
}

variable "enable_delegated_admin" {
  type        = bool
  description = "Register CloudSSO delegated administrator on the member account"
  default     = false
}
