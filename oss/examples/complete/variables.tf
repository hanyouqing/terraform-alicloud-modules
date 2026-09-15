variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "demo"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "buckets" {
  type = map(object({
    name                = string
    storage_class       = optional(string, "Standard")
    redundancy_type     = optional(string, "LRS")
    acl                 = optional(string, "private")
    versioning          = optional(bool, true)
    sse_algorithm       = optional(string, "AES256")
    kms_master_key_id   = optional(string, null)
    force_ssl           = optional(bool, true)
    block_public_access = optional(bool, true)
    tags                = optional(map(string), {})
    lifecycle_rules = optional(list(object({
      id              = string
      enabled         = optional(bool, true)
      prefix          = optional(string, null)
      expiration_days = optional(number, null)
      transitions = optional(list(object({
        days          = number
        storage_class = string
      })), [])
      abort_multipart_days = optional(number, null)
    })), [])
    logging = optional(object({
      target_bucket = string
      target_prefix = optional(string, "oss-access-logs/")
    }), null)
  }))
  description = "Map of buckets for the complete example"
  default     = {}
}
