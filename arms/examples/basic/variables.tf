variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "grafana_instance_id" {
  type        = string
  description = "Existing Grafana workspace ID, or \"free\" when using shared free Grafana"
  default     = "free"
}
