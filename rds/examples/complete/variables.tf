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
  description = "Primary private vSwitch ID"
}

variable "zone_id" {
  type        = string
  description = "Primary zone ID"
}

variable "zone_id_slave_a" {
  type        = string
  description = "Secondary zone ID for HighAvailability"
}

variable "instance_type" {
  type        = string
  description = "RDS instance class (HA-capable)"
  default     = "mysql.n2.medium.1"
}

variable "instance_storage" {
  type        = number
  description = "Storage size in GB"
  default     = 100
}

variable "account_name" {
  type        = string
  description = "Application DB account name"
  default     = "appuser"
}

variable "account_password" {
  type        = string
  description = "Application DB account password (8-32 chars)"
}
