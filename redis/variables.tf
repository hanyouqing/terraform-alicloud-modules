variable "instances" {
  type = map(object({
    db_instance_name    = string
    vswitch_id          = string
    instance_class      = string
    instance_type       = optional(string, "Redis")
    engine_version      = optional(string, "5.0")
    password            = optional(string, null)
    zone_id             = optional(string, null)
    secondary_zone_id   = optional(string, null)
    payment_type        = optional(string, "PostPaid")
    period              = optional(string, null)
    auto_renew          = optional(bool, null)
    ssl_enable          = optional(string, "Enable")
    vpc_auth_mode       = optional(string, "Open")
    security_ips        = optional(list(string), null)
    security_group_id   = optional(string, null)
    maintain_start_time = optional(string, "02:00Z")
    maintain_end_time   = optional(string, "03:00Z")
    backup_period       = optional(list(string), ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
    backup_time         = optional(string, "02:00Z-03:00Z")
    config              = optional(map(string), {})
    tags                = optional(map(string), {})
  }))
  description = "Map of Redis/Tair (KVStore) instances. Do not mark this map sensitive (for_each); passwords remain sensitive on the resource attribute."
  default     = {}

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Redis", "Memcache"], i.instance_type)
    ])
    error_message = "instance_type must be Redis or Memcache."
  }

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Enable", "Disable", "Update"], i.ssl_enable)
    ])
    error_message = "ssl_enable must be Enable, Disable, or Update."
  }

  validation {
    condition = alltrue([
      for i in var.instances : contains(["Open", "Close"], i.vpc_auth_mode)
    ])
    error_message = "vpc_auth_mode must be Open or Close."
  }

  validation {
    condition = alltrue([
      for i in var.instances : i.password == null || (length(i.password) >= 8 && length(i.password) <= 32)
    ])
    error_message = "password must be 8-32 characters when set."
  }
}

variable "default_security_ips" {
  type        = list(string)
  description = "Default security IP whitelist when an instance omits security_ips"
  default     = ["10.0.0.0/8"]
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
