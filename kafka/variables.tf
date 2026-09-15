variable "create_instance" {
  type        = bool
  description = "Whether to create an alikafka instance"
  default     = true
}

variable "instance_name" {
  type        = string
  description = "Kafka instance name"
  default     = null
}

variable "deploy_type" {
  type        = number
  description = "Deploy type: 4=Internet, 5=VPC (typical for enterprise)"
  default     = 5

  validation {
    condition     = contains([4, 5], var.deploy_type)
    error_message = "deploy_type must be 4 (Internet) or 5 (VPC)."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID (required for deploy_type 5)"
  default     = null
}

variable "vswitch_id" {
  type        = string
  description = "Primary vSwitch ID (legacy single-zone)"
  default     = null
}

variable "vswitch_ids" {
  type        = list(string)
  description = "vSwitch IDs (prefer multi-zone for production)"
  default     = []
}

variable "security_group" {
  type        = string
  description = "Security group ID for the Kafka instance"
  default     = null
}

variable "disk_type" {
  type        = number
  description = "Disk type: 0=ultra, 1=SSD"
  default     = 1
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 500
}

variable "partition_num" {
  type        = number
  description = "Partition quota (newer billing models)"
  default     = null
}

variable "topic_quota" {
  type        = number
  description = "Topic quota (legacy)"
  default     = null
}

variable "io_max" {
  type        = number
  description = "Peak traffic (MB/s); mutually exclusive with io_max_spec on some editions"
  default     = null
}

variable "io_max_spec" {
  type        = string
  description = "IO max specification string when using newer SKUs"
  default     = null
}

variable "spec_type" {
  type        = string
  description = "Instance spec type (e.g. normal, professional)"
  default     = "normal"
}

variable "paid_type" {
  type        = string
  description = "Payment type: PostPaid or PrePaid"
  default     = "PostPaid"
}

variable "service_version" {
  type        = string
  description = "Kafka service version"
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "Optional KMS key ID for disk encryption"
  default     = null
}

variable "selected_zones" {
  type        = list(string)
  description = "Optional selected zones"
  default     = []
}

variable "config" {
  type        = string
  description = "Optional instance config JSON string"
  default     = null
}

variable "eip_max" {
  type        = number
  description = "EIP bandwidth when deploy_type is Internet"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
  default     = null
}

variable "instance_id" {
  type        = string
  description = "Existing Kafka instance ID when create_instance is false"
  default     = null
}

variable "topics" {
  type = map(object({
    topic         = optional(string, null)
    remark        = string
    partition_num = optional(number, 3)
    compact_topic = optional(bool, false)
    local_topic   = optional(bool, false)
    configs       = optional(string, null)
    tags          = optional(map(string), {})
  }))
  description = "Map of Kafka topics"
  default     = {}
}

variable "consumer_groups" {
  type = map(object({
    consumer_id = optional(string, null)
    description = optional(string, null)
    remark      = optional(string, null)
    tags        = optional(map(string), {})
  }))
  description = "Map of Kafka consumer groups"
  default     = {}
}

variable "sasl_users" {
  type = map(object({
    username               = optional(string, null)
    password               = optional(string, null)
    type                   = optional(string, "plain")
    mechanism              = optional(string, null)
    kms_encrypted_password = optional(string, null)
    kms_encryption_context = optional(map(string), {})
  }))
  description = "Optional SASL users. Password is sensitive on the resource attribute; this map is not marked sensitive as a whole."
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
