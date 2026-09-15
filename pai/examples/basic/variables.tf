variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "workspace_name" {
  type        = string
  description = "PAI workspace name"
  default     = "demo-pai-ws"
}
