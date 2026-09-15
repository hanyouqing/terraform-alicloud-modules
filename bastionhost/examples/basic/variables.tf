variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_instance" {
  type        = bool
  description = "Create Bastionhost instance (paid). Set false and pass instance_id to skip."
  default     = false
}

variable "instance_id" {
  type        = string
  description = "Existing instance ID when create_instance is false"
  default     = null
}

variable "description" {
  type        = string
  description = "Instance description"
  default     = "basic-bastion"
}

variable "license_code" {
  type        = string
  description = "License code"
  default     = "bhah_ent_50_asset"
}

variable "plan_code" {
  type        = string
  description = "Plan code"
  default     = "cloudbastion"
}

variable "storage" {
  type        = string
  description = "Storage TB"
  default     = "5"
}

variable "bandwidth" {
  type        = string
  description = "Bandwidth Mbps"
  default     = "5"
}

variable "period" {
  type        = number
  description = "Subscription months"
  default     = 1
}

variable "vswitch_id" {
  type        = string
  description = "VSwitch ID (required when create_instance is true)"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs (required when create_instance is true)"
  default     = []
}
