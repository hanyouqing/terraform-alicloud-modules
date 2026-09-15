variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "display_name" {
  type        = string
  description = "Project display name"
  default     = "Demo DataWorks"
}

variable "project_name" {
  type        = string
  description = "Project name (unique)"
  default     = "demo_dataworks"
}
