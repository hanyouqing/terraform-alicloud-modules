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
  description = "Map of AnalyticDB lake-version clusters (alicloud_adb_db_cluster_lake_version). Required per entry: db_cluster_version, payment_type, vpc_id, vswitch_id, zone_id."
  default     = {}

  validation {
    condition = alltrue([
      for c in var.clusters : contains(["PayAsYouGo", "Subscription", "PostPaid", "PrePaid"], c.payment_type)
    ])
    error_message = "payment_type must be PayAsYouGo, Subscription, PostPaid, or PrePaid."
  }
}

variable "default_security_ips" {
  type        = list(string)
  description = "Default security_ips (prefer VPC CIDR) when a cluster omits security_ips"
  default     = ["10.0.0.0/8"]
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
  description = "Optional lake accounts (alicloud_adb_lake_account). Do not mark this map sensitive (for_each); passwords remain on the resource."
  default     = {}

  validation {
    condition = alltrue([
      for a in var.accounts : contains(keys(var.clusters), a.cluster_key)
    ])
    error_message = "accounts.cluster_key must reference an existing clusters map key."
  }
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
  description = "Additional tags (applied where the provider supports tags)"
  default     = {}
}
