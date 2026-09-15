variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "cen_instance_name" {
  type        = string
  description = "CEN instance name"
  default     = "complete-cen"
}

variable "description" {
  type        = string
  description = "CEN description"
  default     = "complete cen with bandwidth"
}

variable "attachments" {
  type = map(object({
    child_instance_id        = string
    child_instance_type      = string
    child_instance_region_id = string
    child_instance_owner_id  = optional(number, null)
  }))
  description = "Child instance attachments"
  default     = {}
}

variable "create_bandwidth_package" {
  type        = bool
  description = "Create bandwidth package"
  default     = true
}

variable "bandwidth_package_name" {
  type        = string
  description = "Bandwidth package name"
  default     = "complete-cen-bwp"
}

variable "bandwidth" {
  type        = number
  description = "Bandwidth Mbps"
  default     = 5
}

variable "geographic_region_a_id" {
  type        = string
  description = "Area A"
  default     = "China"
}

variable "geographic_region_b_id" {
  type        = string
  description = "Area B"
  default     = "China"
}

variable "bandwidth_payment_type" {
  type        = string
  description = "Bandwidth payment type"
  default     = "PostPaid"
}

variable "bandwidth_limits" {
  type = map(object({
    region_ids      = list(string)
    bandwidth_limit = number
  }))
  description = "Inter-region bandwidth limits"
  default     = {}
}

variable "create_transit_router" {
  type        = bool
  description = "Create transit router"
  default     = false
}

variable "transit_router_name" {
  type        = string
  description = "Transit router name"
  default     = "complete-cen-tr"
}

variable "transit_router_region_id" {
  type        = string
  description = "Transit router region"
  default     = null
}

variable "transit_router_vpc_attachments" {
  type = map(object({
    vpc_id = string
    zone_mappings = list(object({
      zone_id    = string
      vswitch_id = string
    }))
    transit_router_attachment_name = optional(string, null)
    auto_publish_route_enabled     = optional(bool, true)
  }))
  description = "Transit router VPC attachments"
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "demo"
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
