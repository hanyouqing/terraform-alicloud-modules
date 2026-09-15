variable "region" {
  type        = string
  description = "Alibaba Cloud region (Direct Mail commonly uses cn-hangzhou)"
  default     = "cn-hangzhou"
}

variable "domain_name" {
  type        = string
  description = "Sender domain to register (must be a domain you control)"
}
