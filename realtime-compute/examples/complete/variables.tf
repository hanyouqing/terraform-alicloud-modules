variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_vvp_instance" {
  type        = bool
  description = "Create VVP instance"
  default     = true
}

variable "vvp_instance_name" {
  type        = string
  description = "VVP instance name"
  default     = "prod-flink"
}

variable "payment_type" {
  type        = string
  description = "Payment type"
  default     = "PayAsYouGo"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-xxxxxxxx"
}

variable "vswitch_ids" {
  type        = list(string)
  description = "vSwitch IDs"
  default     = ["vsw-xxxxxxxx"]
}

variable "zone_id" {
  type        = string
  description = "Zone ID"
  default     = "cn-hangzhou-i"
}

variable "duration" {
  type        = number
  description = "Subscription duration"
  default     = null
}

variable "pricing_cycle" {
  type        = string
  description = "Pricing cycle"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
  default     = null
}

variable "resource_spec" {
  type = object({
    cpu       = optional(number, null)
    memory_gb = optional(number, null)
  })
  description = "CU resource_spec for production"
  default = {
    cpu       = 8
    memory_gb = 32
  }
}

variable "storage" {
  type = object({
    oss_bucket = string
  })
  description = "OSS storage for Flink state"
  default = {
    oss_bucket = "REPLACE_FLINK_STATE_BUCKET"
  }
}

variable "deployments" {
  type = map(object({
    deployment_name = optional(string, null)
    description     = optional(string, null)
    engine_version  = optional(string, null)
    execution_mode  = string
    namespace       = string
    flink_conf      = optional(map(string), {})
    labels          = optional(map(string), {})
    resource_id     = optional(string, null)
    deployment_target = object({
      mode = string
      name = string
    })
    artifact = object({
      kind = string
      jar_artifact = optional(object({
        additional_dependencies = optional(list(string), null)
        entry_class             = optional(string, null)
        jar_uri                 = optional(string, null)
        main_args               = optional(string, null)
      }), null)
      python_artifact = optional(object({
        additional_dependencies     = optional(list(string), null)
        additional_python_archives  = optional(list(string), null)
        additional_python_libraries = optional(list(string), null)
        entry_module                = optional(string, null)
        main_args                   = optional(string, null)
        python_artifact_uri         = optional(string, null)
      }), null)
      sql_artifact = optional(object({
        additional_dependencies = optional(list(string), null)
        sql_script              = optional(string, null)
      }), null)
    })
  }))
  description = "Optional deployments (empty by default). Each entry requires execution_mode, namespace, deployment_target, and artifact."
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
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
