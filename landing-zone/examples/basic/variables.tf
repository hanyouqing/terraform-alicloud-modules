variable "region" {
  type        = string
  description = "Alibaba Cloud region for the provider (RD is global; region is still required by the provider)"
  default     = "cn-hangzhou"
}

variable "create_resource_directory" {
  type        = bool
  description = "Create Resource Directory if one does not already exist on this management account"
  default     = false
}
