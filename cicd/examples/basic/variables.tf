variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "namespace_name" {
  type        = string
  description = "CR namespace name (globally unique in account/region)"
  default     = "tf-cicd-demo"
}

variable "repo_name" {
  type        = string
  description = "Repository name"
  default     = "app"
}
