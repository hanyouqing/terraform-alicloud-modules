variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "domain_name" {
  type        = string
  description = "Public domain to add to Alidns (must be registered and unused by another account)"
}

variable "apex_value" {
  type        = string
  description = "Apex A record value"
}

variable "mx_value" {
  type        = string
  description = "MX record value"
  default     = "mxn.mxhichina.com"
}

variable "private_zone_name" {
  type        = string
  description = "PrivateZone name"
  default     = "internal.example.local"
}

variable "vpc_ids" {
  type        = list(string)
  description = "VPC IDs to attach to the PrivateZone"
  default     = []
}

variable "private_record_value" {
  type        = string
  description = "Private A record value"
  default     = "10.0.1.10"
}
