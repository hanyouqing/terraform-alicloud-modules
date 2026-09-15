variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "image_id" {
  type        = string
  description = "SWAS image ID"
}

variable "plan_id" {
  type        = string
  description = "SWAS plan ID"
}

variable "period" {
  type        = number
  description = "Subscription period in months"
  default     = 1
}
