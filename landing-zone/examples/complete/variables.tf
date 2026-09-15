variable "region" {
  type        = string
  description = "Alibaba Cloud region for the provider"
  default     = "cn-hangzhou"
}

variable "create_resource_directory" {
  type        = bool
  description = "Create Resource Directory if one does not already exist"
  default     = false
}
