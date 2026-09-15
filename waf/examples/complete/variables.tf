variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instance_id" {
  type        = string
  description = "Existing WAFv3 instance ID"
}

variable "www_domain" {
  type        = string
  description = "Primary www domain"
}

variable "api_domain" {
  type        = string
  description = "API domain"
}

variable "backends" {
  type        = list(string)
  description = "Origin backend IP addresses or domain names"
}

variable "cert_id" {
  type        = string
  description = "Certificate ID for HTTPS listen (format may include region suffix)"
  default     = null
}
