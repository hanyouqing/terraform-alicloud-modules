variable "create_instance" {
  type        = bool
  description = "Whether to create a Bastionhost instance. Set false and pass instance_id to manage users/hosts on an existing paid instance."
  default     = true
}

variable "instance_id" {
  type        = string
  description = "Existing Bastionhost instance ID when create_instance is false"
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the Bastionhost instance (required when create_instance is true)"
  default     = "bastionhost"
}

variable "license_code" {
  type        = string
  description = "License code (e.g. bhah_ent_50_asset). Required when create_instance is true."
  default     = null
}

variable "plan_code" {
  type        = string
  description = "Plan code (e.g. cloudbastion / cloudbastion_ha). Required when create_instance is true."
  default     = "cloudbastion"
}

variable "storage" {
  type        = string
  description = "Storage size in TB"
  default     = "5"
}

variable "bandwidth" {
  type        = string
  description = "Bandwidth in Mbps"
  default     = "5"
}

variable "period" {
  type        = number
  description = "Subscription period in months"
  default     = 1
}

variable "vswitch_id" {
  type        = string
  description = "VSwitch ID for the Bastionhost instance"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for the Bastionhost instance"
  default     = []
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
  default     = null
}

variable "enable_public_access" {
  type        = bool
  description = "Whether to enable public network access"
  default     = false
}

variable "public_white_list" {
  type        = list(string)
  description = "Public IP whitelist when public access is enabled"
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
  description = "Map of Bastionhost users (empty for instance-only). Passwords stay on the resource attribute; do not mark this map sensitive (for_each)."
  default     = {}
}

variable "user_groups" {
  type = map(object({
    user_group_name = optional(string, null)
    comment         = optional(string, null)
  }))
  description = "Map of Bastionhost user groups"
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
  description = "Map of Bastionhost hosts"
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
  description = "Map of host accounts. host_key references keys in var.hosts. Do not mark this map sensitive (for_each)."
  default     = {}
}

variable "user_attachments" {
  type = map(object({
    user_key       = string
    user_group_key = string
  }))
  description = "Attach users to user groups by map keys"
  default     = {}
}

variable "host_account_user_attachments" {
  type = map(object({
    host_account_key = string
    user_key         = string
    host_key         = string
  }))
  description = "Attach host accounts to users"
  default     = {}
}

variable "host_account_user_group_attachments" {
  type = map(object({
    host_account_key = string
    user_group_key   = string
    host_key         = string
  }))
  description = "Attach host accounts to user groups"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags merged onto the instance"
  default     = {}
}
