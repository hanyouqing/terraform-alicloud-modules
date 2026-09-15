variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "image_id" {
  type        = string
  description = "ECS image ID"
}

variable "instance_type" {
  type        = string
  description = "ECS instance type"
  default     = "ecs.g7.large"
}

variable "vswitch_id" {
  type        = string
  description = "VSwitch ID for the instance"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}
