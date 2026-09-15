variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_ee_instance" {
  type        = bool
  description = "Create CR EE instance (default false = Personal Edition)"
  default     = false
}

variable "ee_instance_id" {
  type        = string
  description = "Existing EE instance ID"
  default     = null
}

variable "ee_instance_name" {
  type        = string
  description = "EE instance name when creating"
  default     = "tf-complete-cr"
}

variable "ee_instance_type" {
  type        = string
  description = "EE instance type"
  default     = "Basic"
}

variable "ee_period" {
  type        = number
  description = "EE subscription months"
  default     = 1
}

variable "ee_renewal_status" {
  type        = string
  description = "EE renewal status"
  default     = "ManualRenewal"
}

variable "ee_resource_group_id" {
  type        = string
  description = "Optional resource group"
  default     = null
}

variable "namespaces" {
  type = map(object({
    name               = optional(string, null)
    auto_create        = optional(bool, false)
    default_visibility = optional(string, "PRIVATE")
  }))
  description = "Namespaces"
  default = {
    app = {
      auto_create        = false
      default_visibility = "PRIVATE"
    }
    tools = {
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
  description = "Repositories"
  default = {
    api = {
      namespace_key = "app"
      summary       = "API service images"
      repo_type     = "PRIVATE"
      detail        = "Complete example API repo"
    }
    worker = {
      namespace_key = "app"
      summary       = "Worker images"
      repo_type     = "PRIVATE"
    }
    ci-helpers = {
      namespace_key = "tools"
      summary       = "CI helper images"
      repo_type     = "PRIVATE"
    }
  }
}

variable "endpoint_acl_policies" {
  type = map(object({
    entry         = string
    endpoint_type = optional(string, "internet")
    module_name   = optional(string, "Registry")
    description   = optional(string, null)
  }))
  description = "EE endpoint ACL entries (ignored for Personal Edition)"
  default     = {}
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
