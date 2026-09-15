variable "disks" {
  type = map(object({
    disk_name               = string
    zone_id                 = string
    size                    = number
    category                = optional(string, "cloud_essd")
    performance_level       = optional(string, "PL1")
    encrypted               = optional(bool, true)
    kms_key_id              = optional(string, null)
    description             = optional(string, null)
    payment_type            = optional(string, "PayAsYouGo")
    delete_auto_snapshot    = optional(bool, false)
    delete_with_instance    = optional(bool, false)
    auto_snapshot_policy_id = optional(string, null)
    tags                    = optional(map(string), {})
  }))
  description = "Map of ECS disks to create. Defaults to encrypted cloud_essd PL1."
  default     = {}

  validation {
    condition = alltrue([
      for d in var.disks : contains(["cloud_essd", "cloud_ssd", "cloud_efficiency", "cloud_auto", "cloud_essd_entry"], d.category)
    ])
    error_message = "category must be cloud_essd, cloud_ssd, cloud_efficiency, cloud_auto, or cloud_essd_entry."
  }

  validation {
    condition = alltrue([
      for d in var.disks : contains(["PL0", "PL1", "PL2", "PL3"], d.performance_level)
    ])
    error_message = "performance_level must be PL0, PL1, PL2, or PL3."
  }

  validation {
    condition = alltrue([
      for d in var.disks : d.size >= 1 && d.size <= 65536
    ])
    error_message = "size must be between 1 and 65536 GiB."
  }
}

variable "attachments" {
  type = map(object({
    disk_key             = string
    instance_id          = string
    delete_with_instance = optional(bool, false)
  }))
  description = "Optional map of disk attachments to ECS instances"
  default     = {}

  validation {
    condition = alltrue([
      for a in var.attachments : contains(keys(var.disks), a.disk_key)
    ])
    error_message = "All attachments.disk_key values must reference an existing disks map key."
  }
}

variable "snapshot_policies" {
  type = map(object({
    name            = string
    repeat_weekdays = list(string)
    time_points     = list(string)
    retention_days  = optional(number, 7)
    tags            = optional(map(string), {})
  }))
  description = "Optional automatic snapshot policies to create"
  default     = {}
}

variable "snapshot_policy_attachments" {
  type = map(object({
    disk_key            = string
    snapshot_policy_key = string
  }))
  description = "Attach created snapshot policies to disks. Prefer this over disks.auto_snapshot_policy_id when creating policies in-module."
  default     = {}

  validation {
    condition = alltrue([
      for a in var.snapshot_policy_attachments : contains(keys(var.disks), a.disk_key)
    ])
    error_message = "snapshot_policy_attachments.disk_key must reference an existing disks map key."
  }

  validation {
    condition = alltrue([
      for a in var.snapshot_policy_attachments : contains(keys(var.snapshot_policies), a.snapshot_policy_key)
    ])
    error_message = "snapshot_policy_attachments.snapshot_policy_key must reference an existing snapshot_policies map key."
  }
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
  description = "Additional tags applied to all disks"
  default     = {}
}
