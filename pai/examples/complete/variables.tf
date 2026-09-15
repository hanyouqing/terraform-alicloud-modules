variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "workspace_name" {
  type        = string
  description = "PAI workspace name"
  default     = "prod-pai-ws"
}

variable "description" {
  type        = string
  description = "Workspace description"
  default     = "Production PAI workspace for custom LLM training and serving"
}

variable "env_types" {
  type        = set(string)
  description = "Environment types"
  default     = ["prod"]
}

variable "display_name" {
  type        = string
  description = "Display name"
  default     = "prod-pai"
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
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
  description = "Datasets (set a real OSS uri before apply)"
  default = {
    training = {
      data_source_type = "OSS"
      property         = "DIRECTORY"
      uri              = "oss://REPLACE_BUCKET/datasets/train/"
      description      = "Training corpus"
      accessibility    = "PRIVATE"
    }
  }
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
  description = "Models registered in the workspace"
  default = {
    custom-llm = {
      model_type        = "Checkpoint"
      task              = "text-generation"
      model_description = "Custom fine-tuned checkpoint"
      accessibility     = "PRIVATE"
    }
  }
}

variable "services" {
  type = map(object({
    service_config = string
    develop        = optional(string, null)
    status         = optional(string, null)
    tags           = optional(map(string), {})
  }))
  description = "Online services; service_config is flexible JSON"
  default = {
    predictor = {
      service_config = <<-EOT
        {"metadata":{"name":"predictor","instance":1},"cloud":{"computing":{"instanceType":"ecs.c6.large"}}}
      EOT
    }
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
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
