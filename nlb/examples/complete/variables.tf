variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "address_type" {
  type        = string
  description = "Internet or Intranet"
  default     = "Intranet"
}

variable "zone_mappings" {
  type = list(object({
    zone_id    = string
    vswitch_id = string
  }))
  description = "At least two zone mappings for the NLB"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Optional NLB security group IDs"
  default     = []
}

variable "certificate_ids" {
  type        = list(string)
  description = "Optional certificate IDs for TCPSSL listener"
  default     = []
}

variable "backend_servers" {
  type = list(object({
    server_id   = string
    server_type = optional(string, "Ecs")
    port        = number
    weight      = optional(number, 100)
    server_ip   = optional(string, null)
    description = optional(string, null)
  }))
  description = "Optional backend servers for the app server group"
  default     = []
}
