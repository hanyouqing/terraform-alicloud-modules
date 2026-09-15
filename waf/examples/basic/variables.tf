variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instance_id" {
  type        = string
  description = "Existing WAFv3 instance ID (paid product; prefer not creating in examples)"
}

variable "domain" {
  type        = string
  description = "Domain to protect with WAFv3"
}

variable "backends" {
  type        = list(string)
  description = "Origin backend IP addresses or domain names"
}
