variable "domains" {
  type = map(object({
    domain_name = optional(string, null)
  }))
  description = "Map of Direct Mail domains to register. Key is a stable identifier; domain_name defaults to the map key."
  default     = {}
}

variable "mail_addresses" {
  type = map(object({
    account_name  = string
    sendtype      = string
    reply_address = optional(string, null)
    password      = optional(string, null)
  }))
  description = "Map of sender addresses. account_name must be lowercase account@domain; sendtype is batch or trigger."
  default     = {}

  validation {
    condition = alltrue([
      for a in var.mail_addresses : contains(["batch", "trigger"], a.sendtype)
    ])
    error_message = "Each mail_addresses sendtype must be batch or trigger."
  }

  validation {
    condition = alltrue([
      for a in var.mail_addresses : can(regex("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$", a.account_name))
    ])
    error_message = "Each mail_addresses account_name must be a lowercase email address (account@domain)."
  }
}

variable "mail_tags" {
  type = map(object({
    tag_name = optional(string, null)
  }))
  description = "Optional Direct Mail campaign tags (alicloud_direct_mail_tag)"
  default     = {}
}

variable "receivers" {
  type = map(object({
    receivers_name  = optional(string, null)
    receivers_alias = string
    description     = optional(string, null)
  }))
  description = "Optional receiver list metadata (alicloud_direct_mail_receivers). Recipient upload remains out-of-band."
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging / reminders"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging / reminders"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional freeform tags recorded in module locals (Direct Mail domain/address resources do not accept provider tags)"
  default     = {}
}
