variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "web_domain_name" {
  type        = string
  description = "Web CDN domain name"
}

variable "download_domain_name" {
  type        = string
  description = "Download CDN domain name"
}

variable "scope" {
  type        = string
  description = "CDN scope: domestic, overseas, or global"
  default     = "overseas"
}

variable "origin_domain" {
  type        = string
  description = "Origin domain for the web CDN domain"
}

variable "oss_origin" {
  type        = string
  description = "OSS bucket domain for the download CDN domain"
}

variable "ip_allow_list" {
  type        = string
  description = "Comma-separated IP allow list for ip_allow_list_set"
  default     = "127.0.0.1"
}
