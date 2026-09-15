variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "demo"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "default_security_ips" {
  type        = list(string)
  description = "Security IP whitelist (prefer VPC CIDR only)"
  default     = ["10.0.0.0/16"]
}

variable "vswitch_id" {
  type        = string
  description = "Private vSwitch ID"
}

variable "zone_id" {
  type        = string
  description = "Primary zone ID"
}

variable "secondary_zone_id" {
  type        = string
  description = "Secondary zone ID for HA"
  default     = null
}

variable "instance_class" {
  type        = string
  description = "Redis instance class"
  default     = "redis.master.small.default"
}

variable "engine_version" {
  type        = string
  description = "Redis engine version"
  default     = "5.0"
}

variable "password" {
  type        = string
  description = "Redis password"
  sensitive   = true
}
