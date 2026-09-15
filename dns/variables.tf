variable "domains" {
  type = map(object({
    domain_name       = optional(string, null)
    group_id          = optional(string, null)
    resource_group_id = optional(string, null)
    remark            = optional(string, null)
    lang              = optional(string, null)
  }))
  description = "Map of public Alidns domains to create (prefer alicloud_alidns_* over deprecated alicloud_dns_*)"
  default     = {}
}

variable "domain_name" {
  type        = string
  description = "Existing public domain name to attach records to when not creating domains / omitting records.domain_key"
  default     = null
}

variable "records" {
  type = map(object({
    domain_key  = optional(string, null)
    domain_name = optional(string, null)
    rr          = string
    type        = string
    value       = string
    ttl         = optional(number, 600)
    line        = optional(string, "default")
    priority    = optional(number, null)
    status      = optional(string, "ENABLE")
    remark      = optional(string, null)
    lang        = optional(string, null)
  }))
  description = "Map of public Alidns records. Resolve domain via domain_key (from domains), domain_name, or module domain_name."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.records : contains(["A", "AAAA", "CNAME", "TXT", "MX", "NS", "SRV", "CAA", "REDIRECT_URL", "FORWORD_URL"], r.type)
    ])
    error_message = "Each records type must be a supported Alidns record type."
  }
}

variable "private_zones" {
  type = map(object({
    zone_name         = optional(string, null)
    remark            = optional(string, null)
    proxy_pattern     = optional(string, null)
    resource_group_id = optional(string, null)
    lang              = optional(string, null)
    vpc_ids           = optional(list(string), [])
  }))
  description = "Optional PrivateZone zones with optional VPC attachments"
  default     = {}
}

variable "private_zone_records" {
  type = map(object({
    zone_key = string
    rr       = string
    type     = string
    value    = string
    ttl      = optional(number, 60)
    priority = optional(number, null)
    status   = optional(string, "ENABLE")
    remark   = optional(string, null)
    lang     = optional(string, null)
  }))
  description = "Optional PrivateZone records keyed by stable identifiers"
  default     = {}

  validation {
    condition = alltrue([
      for r in var.private_zone_records : contains(["A", "CNAME", "TXT", "MX", "PTR", "SRV"], r.type)
    ])
    error_message = "Each private_zone_records type must be one of: A, CNAME, TXT, MX, PTR, SRV."
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
  description = "Additional tags merged onto all tagged resources"
  default     = {}
}
