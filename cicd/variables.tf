variable "namespaces" {
  type = map(object({
    name               = optional(string, null)
    auto_create        = optional(bool, false)
    default_visibility = optional(string, "PRIVATE")
  }))
  description = "CR Personal Edition namespaces"
  default     = {}

  validation {
    condition = alltrue([
      for n in var.namespaces : contains(["PRIVATE", "PUBLIC"], n.default_visibility)
    ])
    error_message = "default_visibility must be PRIVATE or PUBLIC."
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
  description = "CR Personal Edition repositories (for_each). namespace_key references namespaces map keys."
  default     = {}

  validation {
    condition = alltrue([
      for r in var.repos : contains(["PRIVATE", "PUBLIC"], r.repo_type)
    ])
    error_message = "repo_type must be PRIVATE or PUBLIC."
  }
}

variable "image_pipelines" {
  type = map(object({
    base_image                 = string
    base_image_type            = string
    name                       = optional(string, null)
    image_name                 = optional(string, null)
    description                = optional(string, null)
    build_content              = optional(string, null)
    vswitch_id                 = optional(string, null)
    instance_type              = optional(string, null)
    system_disk_size           = optional(number, null)
    internet_max_bandwidth_out = optional(number, null)
    delete_instance_on_failure = optional(bool, true)
    to_region_id               = optional(list(string), [])
    add_account                = optional(list(string), [])
    resource_group_id          = optional(string, null)
    tags                       = optional(map(string), {})
  }))
  description = "Optional ECS image pipelines (VM image builds)"
  default     = {}

  validation {
    condition = alltrue([
      for p in var.image_pipelines : contains(["IMAGE", "IMAGE_FAMILY"], p.base_image_type)
    ])
    error_message = "base_image_type must be IMAGE or IMAGE_FAMILY."
  }
}

variable "create_ci_role" {
  type        = bool
  description = "Create a RAM role for CI assume-role (e.g. GitHub OIDC / Yunxiao)"
  default     = false
}

variable "ci_role_name" {
  type        = string
  description = "CI RAM role name"
  default     = null
}

variable "ci_role_description" {
  type        = string
  description = "CI RAM role description"
  default     = "CI assume-role for container registry push and image builds"
}

variable "ci_assume_role_policy_document" {
  type        = string
  description = "Assume-role trust policy document for the CI role"
  default     = null
}

variable "ci_max_session_duration" {
  type        = number
  description = "Max session duration for CI role"
  default     = 3600
}

variable "ci_policy_name" {
  type        = string
  description = "CI custom policy name (created when ci_policy_document is set)"
  default     = null
}

variable "ci_policy_document" {
  type        = string
  description = "Optional custom policy document for CR push / related CI permissions. When set, a policy is created and attached to the CI role."
  default     = null
}

variable "ci_policy_description" {
  type        = string
  description = "Description for the CI custom policy"
  default     = "CI permissions for Container Registry push"
}

variable "ci_attach_system_policies" {
  type = map(object({
    policy_name = string
    policy_type = optional(string, "System")
  }))
  description = "Optional system/custom policies to attach to the CI role by name"
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
  description = "Additional tags"
  default     = {}
}
