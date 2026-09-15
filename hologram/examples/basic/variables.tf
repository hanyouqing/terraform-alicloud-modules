variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "zone_id" {
  type        = string
  description = "Zone ID"
}

variable "instance_type" {
  type        = string
  description = "Hologres instance type"
  default     = "Standard"
}

variable "cpu" {
  type        = number
  description = "CPU cores"
  default     = 8
}
