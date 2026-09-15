variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instance_id" {
  type        = string
  description = "ECS instance ID for the sample CPU alarm dimensions"
}

variable "existing_contact_names" {
  type        = list(string)
  description = "Existing CMS contact names to attach to the ops group (contacts must already be activated)"
  default     = []
}
