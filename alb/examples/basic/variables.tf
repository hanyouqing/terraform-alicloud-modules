variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "zone_mappings" {
  type = list(object({
    zone_id    = string
    vswitch_id = string
  }))
  description = "At least two zone mappings for the ALB"
}
