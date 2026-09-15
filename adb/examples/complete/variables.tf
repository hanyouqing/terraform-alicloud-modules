variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "default_security_ips" {
  type        = list(string)
  description = "Default security IPs (VPC CIDR)"
  default     = ["10.0.0.0/16"]
}

variable "clusters" {
  type = map(object({
    db_cluster_version            = string
    payment_type                  = string
    vpc_id                        = string
    vswitch_id                    = string
    zone_id                       = string
    db_cluster_description        = optional(string, null)
    compute_resource              = optional(string, null)
    storage_resource              = optional(string, null)
    disk_encryption               = optional(bool, true)
    enable_ssl                    = optional(bool, true)
    kms_id                        = optional(string, null)
    security_ips                  = optional(list(string), null)
    period                        = optional(number, null)
    product_form                  = optional(string, null)
    product_version               = optional(string, null)
    reserved_node_count           = optional(number, null)
    reserved_node_size            = optional(string, null)
    resource_group_id             = optional(string, null)
    enable_default_resource_group = optional(bool, null)
    secondary_vswitch_id          = optional(string, null)
    secondary_zone_id             = optional(string, null)
    backup_set_id                 = optional(string, null)
    restore_to_time               = optional(string, null)
    restore_type                  = optional(string, null)
    source_db_cluster_id          = optional(string, null)
  }))
  description = "Lake clusters map"
  default     = {}
}

variable "accounts" {
  type = map(object({
    cluster_key         = string
    account_name        = string
    account_password    = string
    account_type        = optional(string, "Normal")
    account_description = optional(string, null)
    ram_user_list       = optional(set(string), [])
  }))
  description = "Optional lake accounts (map not wholly sensitive)"
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
