variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "domains" {
  type = map(object({
    domain_name = optional(string, null)
  }))
  description = "Domains to register"
  default = {
    "mail.example.com" = {}
  }
}

variable "mail_addresses" {
  type = map(object({
    account_name  = string
    sendtype      = string
    reply_address = optional(string, null)
    password      = optional(string, null)
  }))
  description = "Sender addresses"
  default = {
    noreply = {
      account_name  = "noreply@mail.example.com"
      sendtype      = "batch"
      reply_address = "support@mail.example.com"
    }
    alerts = {
      account_name = "alerts@mail.example.com"
      sendtype     = "trigger"
    }
  }
}

variable "mail_tags" {
  type = map(object({
    tag_name = optional(string, null)
  }))
  description = "Campaign tags"
  default = {
    transactional = {
      tag_name = "transactional"
    }
    marketing = {
      tag_name = "marketing"
    }
  }
}

variable "receivers" {
  type = map(object({
    receivers_name  = optional(string, null)
    receivers_alias = string
    description     = optional(string, null)
  }))
  description = "Receiver list metadata"
  default = {
    newsletter = {
      receivers_name  = "newsletter"
      receivers_alias = "newsletter@onaliyun.com"
      description     = "Newsletter audience list"
    }
  }
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
