variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "namespaces" {
  type = map(object({
    name               = optional(string, null)
    auto_create        = optional(bool, false)
    default_visibility = optional(string, "PRIVATE")
  }))
  description = "CR namespaces"
  default = {
    prod = {
      auto_create        = false
      default_visibility = "PRIVATE"
    }
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
  description = "CR repositories"
  default = {
    api = {
      namespace_key = "prod"
      summary       = "API service images"
      repo_type     = "PRIVATE"
    }
    worker = {
      namespace_key = "prod"
      summary       = "Worker images"
      repo_type     = "PRIVATE"
    }
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
  description = "Optional ECS image pipelines (leave empty to skip)"
  default     = {}
}

variable "create_ci_role" {
  type        = bool
  description = "Create CI assume-role"
  default     = true
}

variable "ci_role_name" {
  type        = string
  description = "CI role name"
  default     = "ci-pipeline"
}

variable "ci_assume_role_policy_document" {
  type        = string
  description = "Trust policy for CI role (OIDC / account principal). Replace before apply."
  default     = <<-EOT
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "RAM": ["acs:ram::1234567890123456:root"]
        }
      }
    ],
    "Version": "1"
  }
  EOT
}

variable "ci_policy_document" {
  type        = string
  description = "Optional custom CI policy; null uses module default CR push policy"
  default     = null
}

variable "ci_policy_name" {
  type        = string
  description = "CI policy name"
  default     = null
}

variable "ci_attach_system_policies" {
  type = map(object({
    policy_name = string
    policy_type = optional(string, "System")
  }))
  description = "Extra policies to attach"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
