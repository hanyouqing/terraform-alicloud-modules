variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "namespace_name" {
  type        = string
  description = "Personal Edition namespace name (globally unique in the account/region)"
  default     = "tf-example-ns"
}

variable "repo_name" {
  type        = string
  description = "Repository name"
  default     = "app"
}
