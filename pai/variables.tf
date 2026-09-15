variable "workspace_name" {
  type        = string
  description = "PAI workspace name (required)"
}

variable "description" {
  type        = string
  description = "PAI workspace description (required)"
}

variable "env_types" {
  type        = set(string)
  description = "Environment types for the workspace (required), e.g. [\"prod\"] or [\"dev\", \"prod\"]"
}

variable "display_name" {
  type        = string
  description = "Optional display name for the workspace"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID for the workspace"
  default     = null
}

variable "datasets" {
  type = map(object({
    dataset_name     = optional(string, null)
    data_source_type = string
    property         = string
    uri              = string
    accessibility    = optional(string, null)
    data_type        = optional(string, null)
    description      = optional(string, null)
    options          = optional(string, null)
    source_id        = optional(string, null)
    source_type      = optional(string, null)
    labels = optional(list(object({
      key   = optional(string, null)
      value = optional(string, null)
    })), [])
  }))
  description = "Optional PAI datasets (alicloud_pai_workspace_dataset). Required per entry: data_source_type, property, uri."
  default     = {}
}

variable "models" {
  type = map(object({
    model_name        = optional(string, null)
    accessibility     = optional(string, null)
    domain            = optional(string, null)
    extra_info        = optional(map(string), {})
    model_description = optional(string, null)
    model_doc         = optional(string, null)
    model_type        = optional(string, null)
    order_number      = optional(number, null)
    origin            = optional(string, null)
    task              = optional(string, null)
    labels = optional(list(object({
      key   = optional(string, null)
      value = optional(string, null)
    })), [])
  }))
  description = "Optional PAI models (alicloud_pai_workspace_model). model_name defaults to map key."
  default     = {}
}

variable "services" {
  type = map(object({
    service_config = string
    develop        = optional(string, null)
    status         = optional(string, null)
    tags           = optional(map(string), {})
  }))
  description = "Optional PAI online services (alicloud_pai_service). service_config is a flexible JSON/string payload."
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
  description = "Additional tags applied to taggable resources (pai_service)"
  default     = {}
}
