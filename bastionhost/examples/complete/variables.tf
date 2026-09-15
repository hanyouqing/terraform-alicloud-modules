variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_instance" {
  type        = bool
  description = "Create Bastionhost instance"
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
  default     = "complete-bastion"
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
  description = "VSwitch ID"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs"
  default     = []
}

variable "users" {
  type = map(object({
    user_name           = optional(string, null)
    display_name        = optional(string, null)
    source              = optional(string, "Local")
    password            = optional(string, null)
    email               = optional(string, null)
    mobile              = optional(string, null)
    mobile_country_code = optional(string, "CN")
    comment             = optional(string, null)
    status              = optional(string, "Normal")
  }))
  description = "Users map"
  default     = {}
}

variable "user_groups" {
  type = map(object({
    user_group_name = optional(string, null)
    comment         = optional(string, null)
  }))
  description = "User groups map"
  default     = {}
}

variable "hosts" {
  type = map(object({
    host_name            = optional(string, null)
    active_address_type  = optional(string, "Private")
    host_private_address = optional(string, null)
    host_public_address  = optional(string, null)
    os_type              = optional(string, "Linux")
    source               = optional(string, "Local")
    source_instance_id   = optional(string, null)
    comment              = optional(string, null)
  }))
  description = "Hosts map"
  default     = {}
}

variable "host_accounts" {
  type = map(object({
    host_key          = string
    host_account_name = optional(string, null)
    protocol_name     = optional(string, "SSH")
    password          = optional(string, null)
    private_key       = optional(string, null)
    pass_phrase       = optional(string, null)
  }))
  description = "Host accounts map"
  default     = {}
}

variable "user_attachments" {
  type = map(object({
    user_key       = string
    user_group_key = string
  }))
  description = "User to group attachments"
  default     = {}
}

variable "host_account_user_attachments" {
  type = map(object({
    host_account_key = string
    user_key         = string
    host_key         = string
  }))
  description = "Host account to user attachments"
  default     = {}
}

variable "host_account_user_group_attachments" {
  type = map(object({
    host_account_key = string
    user_group_key   = string
    host_key         = string
  }))
  description = "Host account to user group attachments"
  default     = {}
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
