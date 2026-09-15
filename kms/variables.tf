variable "description" {
  type        = string
  description = "Description of the KMS CMK"
  default     = "Managed by Terraform"
}

variable "pending_window_in_days" {
  type        = number
  description = "Waiting period in days before a deleted CMK is purged (7-366)"
  default     = 30

  validation {
    condition     = var.pending_window_in_days >= 7 && var.pending_window_in_days <= 366
    error_message = "pending_window_in_days must be between 7 and 366."
  }
}

variable "protection_level" {
  type        = string
  description = "Key protection level: SOFTWARE (default) or HSM"
  default     = "SOFTWARE"

  validation {
    condition     = contains(["SOFTWARE", "HSM"], var.protection_level)
    error_message = "protection_level must be SOFTWARE or HSM."
  }
}

variable "key_usage" {
  type        = string
  description = "Intended key usage"
  default     = "ENCRYPT/DECRYPT"
}

variable "key_spec" {
  type        = string
  description = "Key specification (e.g. Aliyun_AES_256)"
  default     = "Aliyun_AES_256"
}

variable "automatic_rotation" {
  type        = string
  description = "Whether automatic rotation is Enabled or Disabled"
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.automatic_rotation)
    error_message = "automatic_rotation must be Enabled or Disabled."
  }
}

variable "rotation_interval" {
  type        = string
  description = "Rotation interval when automatic_rotation is Enabled (e.g. 90d). Required when Enabled."
  default     = null
}

variable "status" {
  type        = string
  description = "CMK status: Enabled or Disabled"
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.status)
    error_message = "status must be Enabled or Disabled."
  }
}

variable "dkms_instance_id" {
  type        = string
  description = "Optional Dedicated KMS instance ID"
  default     = null
}

variable "policy" {
  type        = string
  description = "Optional key policy JSON document"
  default     = null
}

variable "create_alias" {
  type        = bool
  description = "Whether to create a KMS alias for the key"
  default     = false
}

variable "alias_name" {
  type        = string
  description = "Alias name (with or without alias/ prefix). Required when create_alias is true."
  default     = null
}

variable "secrets" {
  type = map(object({
    secret_data                   = string
    version_id                    = optional(string, "v1")
    description                   = optional(string, null)
    secret_type                   = optional(string, "Generic")
    version_stages                = optional(list(string), ["ACSCurrent"])
    encryption_key_id             = optional(string, null)
    force_delete_without_recovery = optional(bool, false)
    recovery_window_in_days       = optional(number, 30)
  }))
  description = "Optional map of KMS secrets. Treat secret_data as confidential; only IDs are outputted."
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
  description = "Additional tags merged onto all tagged resources"
  default     = {}
}
