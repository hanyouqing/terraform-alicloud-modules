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
  description = "Map of OSS buckets to create. Versioning defaults to enabled; ACL defaults to private; SSE defaults to AES256."
  default     = {}

  validation {
    condition = alltrue([
      for b in var.buckets : can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", b.name))
    ])
    error_message = "Each bucket name must be 3-63 chars, lowercase alphanumeric with hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition = alltrue([
      for b in var.buckets : contains(["Standard", "IA", "Archive", "ColdArchive", "DeepColdArchive"], b.storage_class)
    ])
    error_message = "storage_class must be Standard, IA, Archive, ColdArchive, or DeepColdArchive."
  }

  validation {
    condition = alltrue([
      for b in var.buckets : contains(["private", "public-read", "public-read-write"], b.acl)
    ])
    error_message = "acl must be private, public-read, or public-read-write."
  }

  validation {
    condition = alltrue([
      for b in var.buckets : contains(["AES256", "KMS"], b.sse_algorithm)
    ])
    error_message = "sse_algorithm must be AES256 or KMS."
  }

  validation {
    condition = alltrue([
      for b in var.buckets : b.sse_algorithm != "KMS" || (b.kms_master_key_id != null && length(trimspace(b.kms_master_key_id)) > 0)
    ])
    error_message = "kms_master_key_id is required when sse_algorithm is KMS."
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
  description = "Additional tags applied to all buckets"
  default     = {}
}
