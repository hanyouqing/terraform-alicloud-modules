variable "create_ee_instance" {
  type        = bool
  description = "Whether to create a Container Registry Enterprise Edition instance. When false and ee_instance_id is null, Personal Edition namespaces/repos are used."
  default     = false
}

variable "ee_instance_id" {
  type        = string
  description = "Existing CR EE instance ID when create_ee_instance is false but EE namespaces/repos are desired"
  default     = null
}

variable "ee_instance_name" {
  type        = string
  description = "Name of the CR EE instance when create_ee_instance is true"
  default     = null
}

variable "ee_instance_type" {
  type        = string
  description = "CR EE instance type: Basic, Standard, Advanced, or Economy"
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Advanced", "Economy"], var.ee_instance_type)
    error_message = "ee_instance_type must be Basic, Standard, Advanced, or Economy."
  }
}

variable "ee_payment_type" {
  type        = string
  description = "Payment type for CR EE instance (Subscription)"
  default     = "Subscription"
}

variable "ee_period" {
  type        = number
  description = "Subscription period in months for CR EE instance"
  default     = 1
}

variable "ee_renewal_status" {
  type        = string
  description = "Renewal status: AutoRenewal or ManualRenewal"
  default     = "ManualRenewal"

  validation {
    condition     = contains(["AutoRenewal", "ManualRenewal"], var.ee_renewal_status)
    error_message = "ee_renewal_status must be AutoRenewal or ManualRenewal."
  }
}

variable "ee_renew_period" {
  type        = number
  description = "Auto-renewal period in months when ee_renewal_status is AutoRenewal"
  default     = null
}

variable "ee_password" {
  type        = string
  description = "Optional registry login password for the EE instance (8-32 chars)"
  default     = null
  sensitive   = true
}

variable "ee_resource_group_id" {
  type        = string
  description = "Resource group ID for the CR EE instance"
  default     = null
}

variable "ee_image_scanner" {
  type        = string
  description = "Image scanner: ACR, SAS, or DISABLE"
  default     = null

  validation {
    condition     = var.ee_image_scanner == null || contains(["ACR", "SAS", "DISABLE"], var.ee_image_scanner)
    error_message = "ee_image_scanner must be ACR, SAS, or DISABLE."
  }
}

variable "namespaces" {
  type = map(object({
    name               = optional(string, null)
    auto_create        = optional(bool, false)
    default_visibility = optional(string, "PRIVATE")
  }))
  description = "Map of namespaces (Personal Edition when EE is not enabled; EE namespaces when create_ee_instance or ee_instance_id is set)"
  default     = {}

  validation {
    condition = alltrue([
      for n in var.namespaces : contains(["PUBLIC", "PRIVATE"], n.default_visibility)
    ])
    error_message = "Each namespaces default_visibility must be PUBLIC or PRIVATE."
  }
}

variable "repos" {
  type = map(object({
    namespace_key = string
    name          = optional(string, null)
    summary       = string
    repo_type     = optional(string, "PRIVATE")
    detail        = optional(string, null)
  }))
  description = "Map of repositories. namespace_key must reference an entry in namespaces."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.repos : contains(["PUBLIC", "PRIVATE"], r.repo_type)
    ])
    error_message = "Each repos repo_type must be PUBLIC or PRIVATE."
  }
}

variable "endpoint_acl_policies" {
  type = map(object({
    entry         = string
    endpoint_type = optional(string, "internet")
    module_name   = optional(string, "Registry")
    description   = optional(string, null)
  }))
  description = "Optional CR EE internet endpoint ACL CIDR entries (requires an EE instance)"
  default     = {}
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
  description = "Additional tags merged onto tagged resources (EE instance)"
  default     = {}
}
