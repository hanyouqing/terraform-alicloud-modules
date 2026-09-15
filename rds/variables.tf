variable "instances" {
  type = map(object({
    engine                   = string
    engine_version           = string
    instance_type            = string
    instance_storage         = number
    instance_name            = string
    vswitch_id               = string
    zone_id                  = optional(string, null)
    zone_id_slave_a          = optional(string, null)
    instance_charge_type     = optional(string, "Postpaid")
    period                   = optional(number, null)
    auto_renew               = optional(bool, null)
    db_instance_storage_type = optional(string, "cloud_essd")
    category                 = optional(string, null)
    security_ips             = optional(list(string), null)
    security_group_ids       = optional(list(string), [])
    ssl_action               = optional(string, "Open")
    encryption_key           = optional(string, null)
    tde_status               = optional(string, null)
    deletion_protection      = optional(bool, true)
    force_restart            = optional(bool, false)
    tags                     = optional(map(string), {})
    backup = optional(object({
      preferred_backup_period     = optional(list(string), ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
      preferred_backup_time       = optional(string, "02:00Z-03:00Z")
      backup_retention_period     = optional(number, 7)
      enable_backup_log           = optional(bool, true)
      log_backup_retention_period = optional(number, 7)
    }), {})
  }))
  description = "Map of RDS instances (MySQL or PostgreSQL). security_ips defaults to var.default_security_ips (VPC CIDR)."
  default     = {}

  validation {
    condition = alltrue([
      for i in var.instances : contains(["MySQL", "PostgreSQL"], i.engine)
    ])
    error_message = "engine must be MySQL or PostgreSQL."
  }

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Postpaid", "Prepaid"], i.instance_charge_type)
    ])
    error_message = "instance_charge_type must be Postpaid or Prepaid."
  }

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Open", "Close", "Update"], i.ssl_action)
    ])
    error_message = "ssl_action must be Open, Close, or Update."
  }

  validation {
    condition = alltrue([
      for i in var.instances : i.instance_storage >= 20
    ])
    error_message = "instance_storage must be at least 20 GB."
  }
}

variable "default_security_ips" {
  type        = list(string)
  description = "Default security IP whitelist when an instance omits security_ips. Lock to your VPC CIDR in production."
  default     = ["10.0.0.0/8"]
}

variable "accounts" {
  type = map(object({
    instance_key        = string
    account_name        = string
    account_password    = string
    account_type        = optional(string, "Normal")
    account_description = optional(string, null)
  }))
  description = "Optional RDS accounts (alicloud_rds_account). Do not mark this map sensitive (for_each); passwords remain on the resource."
  default     = {}

  validation {
    condition = alltrue([
      for a in var.accounts : contains(keys(var.instances), a.instance_key)
    ])
    error_message = "accounts.instance_key must reference an existing instances map key."
  }

  validation {
    condition = alltrue([
      for a in var.accounts : length(a.account_password) >= 8 && length(a.account_password) <= 32
    ])
    error_message = "account_password must be 8-32 characters."
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
  description = "Additional tags applied to all instances"
  default     = {}
}
