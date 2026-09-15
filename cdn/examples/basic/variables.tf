variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "domain_name" {
  type        = string
  description = "CDN accelerated domain name"
}

variable "origin_ip" {
  type        = string
  description = "Origin IP address"
}
