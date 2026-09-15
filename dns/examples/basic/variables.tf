variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "domain_name" {
  type        = string
  description = "Existing Alidns domain name"
}

variable "record_value" {
  type        = string
  description = "A record value for www"
}
