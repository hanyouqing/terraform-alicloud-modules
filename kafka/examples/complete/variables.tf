variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instance_name" {
  type        = string
  description = "Kafka instance name"
  default     = "prod-kafka"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vswitch_ids" {
  type        = list(string)
  description = "Multi-zone vSwitch IDs"
}

variable "security_group" {
  type        = string
  description = "Security group ID"
}

variable "kms_key_id" {
  type        = string
  description = "Optional KMS key for disk encryption"
  default     = null
}

variable "disk_size" {
  type        = number
  description = "Disk size GB"
  default     = 500
}

variable "partition_num" {
  type        = number
  description = "Partition quota"
  default     = 50
}

variable "spec_type" {
  type        = string
  description = "Instance spec type"
  default     = "professional"
}

variable "service_version" {
  type        = string
  description = "Kafka service version"
  default     = null
}

variable "topics" {
  type = map(object({
    topic         = optional(string, null)
    remark        = string
    partition_num = optional(number, 6)
    compact_topic = optional(bool, false)
    local_topic   = optional(bool, false)
    configs       = optional(string, null)
    tags          = optional(map(string), {})
  }))
  description = "Topics"
  default = {
    orders = {
      remark        = "order events"
      partition_num = 6
    }
    audit = {
      remark        = "audit trail"
      partition_num = 3
    }
  }
}

variable "consumer_groups" {
  type = map(object({
    consumer_id = optional(string, null)
    description = optional(string, null)
    remark      = optional(string, null)
    tags        = optional(map(string), {})
  }))
  description = "Consumer groups"
  default = {
    order-worker = {
      description = "order processing"
    }
    audit-sink = {
      description = "audit sink"
    }
  }
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
  description = "SASL users (set password via tfvars; not wholly sensitive map)"
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
