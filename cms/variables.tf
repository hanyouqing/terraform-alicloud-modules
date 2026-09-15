variable "contacts" {
  type = map(object({
    alarm_contact_name     = optional(string, null)
    describe               = string
    channels_mail          = optional(string, null)
    channels_sms           = optional(string, null)
    channels_ding_web_hook = optional(string, null)
    channels_aliim         = optional(string, null)
    lang                   = optional(string, null)
  }))
  description = "Map of CMS alarm contacts. Prefer DingTalk/email over SMS in production."
  default     = {}
}

variable "contact_groups" {
  type = map(object({
    alarm_contact_group_name = optional(string, null)
    describe                 = optional(string, null)
    enable_subscribed        = optional(bool, false)
    contacts                 = optional(list(string), [])
  }))
  description = "Map of contact groups. contacts entries may be keys from contacts or literal contact names."
  default     = {}
}

variable "alarms" {
  type = map(object({
    name                = optional(string, null)
    project             = string
    metric              = string
    contact_groups      = list(string)
    period              = optional(number, 300)
    silence_time        = optional(number, 86400)
    webhook             = optional(string, null)
    enabled             = optional(bool, true)
    effective_interval  = optional(string, "00:00-23:59")
    metric_dimensions   = optional(string, null)
    dimensions          = optional(any, null)
    statistics          = optional(string, "Average")
    comparison_operator = optional(string, ">=")
    threshold           = string
    times               = optional(number, 3)
    warn = optional(object({
      statistics          = optional(string, "Average")
      comparison_operator = optional(string, ">=")
      threshold           = string
      times               = optional(number, 3)
    }), null)
    info = optional(object({
      statistics          = optional(string, "Average")
      comparison_operator = optional(string, ">=")
      threshold           = string
      times               = optional(number, 3)
    }), null)
  }))
  description = "Map of metric alarms. contact_groups should reference group keys or existing group names (prefer groups over individual SMS)."
  default     = {}

  validation {
    condition = alltrue([
      for a in var.alarms : a.silence_time >= 300 && a.silence_time <= 86400
    ])
    error_message = "Each alarms silence_time must be between 300 and 86400 seconds."
  }
}

variable "site_monitors" {
  type = map(object({
    address   = string
    task_name = optional(string, null)
    task_type = optional(string, "HTTP")
    interval  = optional(number, 5)
    status    = optional(string, null)
    isp_cities = optional(list(object({
      city = optional(string, null)
      isp  = optional(string, null)
      type = optional(string, null)
    })), [])
  }))
  description = "Optional map of CMS site monitors"
  default     = {}

  validation {
    condition = alltrue([
      for s in var.site_monitors : contains(["HTTP", "PING", "TCP", "UDP", "DNS", "SMTP", "POP3", "FTP"], s.task_type)
    ])
    error_message = "Each site_monitors task_type must be one of: HTTP, PING, TCP, UDP, DNS, SMTP, POP3, FTP."
  }
}

variable "monitor_group" {
  type = object({
    monitor_group_name  = string
    contact_groups      = optional(list(string), [])
    resource_group_id   = optional(string, null)
    resource_group_name = optional(string, null)
  })
  description = "Optional CMS application/monitor group"
  default     = null
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
