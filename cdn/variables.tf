variable "domains" {
  type = map(object({
    domain_name       = optional(string, null)
    cdn_type          = optional(string, "web")
    scope             = optional(string, "domestic")
    resource_group_id = optional(string, null)
    sources = list(object({
      type     = optional(string, "domain")
      content  = string
      port     = optional(number, 80)
      priority = optional(number, 20)
      weight   = optional(number, 10)
    }))
    configs = optional(map(object({
      function_name = string
      parent_id     = optional(string, null)
      function_args = list(object({
        arg_name  = string
        arg_value = string
      }))
    })), {})
  }))
  description = "Map of CDN accelerated domains (alicloud_cdn_domain_new) with optional domain configs"
  default     = {}

  validation {
    condition = alltrue([
      for d in var.domains : contains(["web", "download", "video"], d.cdn_type)
    ])
    error_message = "Each domains cdn_type must be web, download, or video."
  }

  validation {
    condition = alltrue([
      for d in var.domains : contains(["domestic", "overseas", "global"], d.scope)
    ])
    error_message = "Each domains scope must be domestic, overseas, or global."
  }

  validation {
    condition = alltrue([
      for d in var.domains : length(d.sources) > 0
    ])
    error_message = "Each domains entry requires at least one source."
  }

  validation {
    condition = alltrue(flatten([
      for d in var.domains : [
        for s in d.sources : contains(["ipaddr", "domain", "oss"], s.type)
      ]
    ]))
    error_message = "Each sources type must be ipaddr, domain, or oss."
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
