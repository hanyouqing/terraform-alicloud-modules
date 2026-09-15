variable "cen_instance_name" {
  type        = string
  description = "Name of the Cloud Enterprise Network (CEN) instance"
  default     = "cen"

  validation {
    condition     = length(var.cen_instance_name) >= 2 && length(var.cen_instance_name) <= 128
    error_message = "cen_instance_name must be between 2 and 128 characters."
  }
}

variable "description" {
  type        = string
  description = "Description of the CEN instance"
  default     = null
}

variable "protection_level" {
  type        = string
  description = "CEN protection level (REDUCED or FULL)"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
  default     = null
}

variable "attachments" {
  type = map(object({
    child_instance_id        = string
    child_instance_type      = string
    child_instance_region_id = string
    child_instance_owner_id  = optional(number, null)
  }))
  description = "Map of child instance attachments (VPC / VBR / CCN)"
  default     = {}

  validation {
    condition = alltrue([
      for a in var.attachments : contains(["VPC", "VBR", "CCN"], a.child_instance_type)
    ])
    error_message = "child_instance_type must be VPC, VBR, or CCN."
  }
}

variable "create_bandwidth_package" {
  type        = bool
  description = "Whether to create and attach a CEN bandwidth package"
  default     = false
}

variable "bandwidth_package_name" {
  type        = string
  description = "Name of the CEN bandwidth package"
  default     = "cen-bandwidth"
}

variable "bandwidth" {
  type        = number
  description = "Bandwidth package capacity in Mbps (minimum 2)"
  default     = 5

  validation {
    condition     = var.bandwidth >= 2
    error_message = "bandwidth must be at least 2 Mbps."
  }
}

variable "geographic_region_a_id" {
  type        = string
  description = "Bandwidth package area A (China, North-America, Asia-Pacific, Europe, Australia)"
  default     = "China"
}

variable "geographic_region_b_id" {
  type        = string
  description = "Bandwidth package area B"
  default     = "China"
}

variable "bandwidth_payment_type" {
  type        = string
  description = "Bandwidth package payment type (PrePaid or PostPaid)"
  default     = "PostPaid"

  validation {
    condition     = contains(["PrePaid", "PostPaid"], var.bandwidth_payment_type)
    error_message = "bandwidth_payment_type must be PrePaid or PostPaid."
  }
}

variable "bandwidth_period" {
  type        = number
  description = "PrePaid bandwidth package period in months"
  default     = null
}

variable "bandwidth_limits" {
  type = map(object({
    region_ids      = list(string)
    bandwidth_limit = number
  }))
  description = "Optional inter-region bandwidth limits (requires attached bandwidth package)"
  default     = {}

  validation {
    condition = alltrue([
      for b in var.bandwidth_limits : length(b.region_ids) == 2
    ])
    error_message = "Each bandwidth_limits entry requires exactly two region_ids."
  }
}

variable "create_transit_router" {
  type        = bool
  description = "Whether to create a CEN transit router in transit_router_region_id"
  default     = false
}

variable "transit_router_name" {
  type        = string
  description = "Transit router name"
  default     = "cen-tr"
}

variable "transit_router_region_id" {
  type        = string
  description = "Region for the transit router (required when create_transit_router is true)"
  default     = null
}

variable "transit_router_description" {
  type        = string
  description = "Transit router description"
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
  description = "Optional transit router VPC attachments (requires create_transit_router)"
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
  description = "Additional tags merged onto tagged resources"
  default     = {}
}
