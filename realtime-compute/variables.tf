variable "create_vvp_instance" {
  type        = bool
  description = "Whether to create a Realtime Compute VVP instance"
  default     = true
}

variable "vvp_instance_name" {
  type        = string
  description = "VVP instance name (required when create_vvp_instance)"
  default     = null
}

variable "payment_type" {
  type        = string
  description = "Payment type (e.g. PayAsYouGo, Subscription)"
  default     = "PayAsYouGo"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the VVP instance"
  default     = null
}

variable "vswitch_ids" {
  type        = list(string)
  description = "vSwitch IDs for the VVP instance"
  default     = []
}

variable "zone_id" {
  type        = string
  description = "Zone ID for the VVP instance"
  default     = null
}

variable "duration" {
  type        = number
  description = "Subscription duration when payment_type is Subscription"
  default     = null
}

variable "pricing_cycle" {
  type        = string
  description = "Pricing cycle for subscription (e.g. Month)"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "resource_spec" {
  type = object({
    cpu       = optional(number, null)
    memory_gb = optional(number, null)
  })
  description = "Optional CU resource_spec block"
  default     = null
}

variable "storage" {
  type = object({
    oss_bucket = string
  })
  description = "Required storage block when creating VVP instance (OSS bucket for Flink checkpoints/state)"
  default     = null
}

variable "vvp_resource_id" {
  type        = string
  description = "Existing VVP resource/workspace ID when create_vvp_instance=false (used by deployments)"
  default     = null
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
  description = "Optional Realtime Compute deployments. Required per entry: execution_mode, namespace, deployment_target, artifact (kind + jar/python/sql)."
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
  description = "Additional tags applied to the VVP instance"
  default     = {}
}
