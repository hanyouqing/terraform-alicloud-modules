variable "create_cluster" {
  type        = bool
  description = "Whether to create an EMR v2 cluster"
  default     = true
}

variable "applications" {
  type        = set(string)
  description = "EMR applications (e.g. SPARK, HIVE, HDFS, YARN)"
  default     = ["SPARK", "HIVE", "HDFS", "YARN"]
}

variable "cluster_name" {
  type        = string
  description = "EMR cluster name"
  default     = null
}

variable "cluster_type" {
  type        = string
  description = "EMR cluster type (e.g. DATALAKE, HADOOP)"
  default     = "DATALAKE"
}

variable "release_version" {
  type        = string
  description = "EMR release version (e.g. EMR-5.10.0)"
  default     = "EMR-5.10.0"
}

variable "payment_type" {
  type        = string
  description = "Cluster payment type (PayAsYouGo or Subscription)"
  default     = "PayAsYouGo"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection"
  default     = false
}

variable "deploy_mode" {
  type        = string
  description = "Deploy mode when supported"
  default     = null
}

variable "security_mode" {
  type        = string
  description = "Security mode (e.g. NORMAL, KERBEROS)"
  default     = "NORMAL"
}

variable "log_collect_strategy" {
  type        = string
  description = "Log collection strategy"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
  default     = null
}

variable "node_attributes" {
  type = list(object({
    vpc_id                 = string
    zone_id                = string
    security_group_id      = string
    key_pair_name          = string
    ram_role               = string
    data_disk_encrypted    = optional(bool, true)
    data_disk_kms_key_id   = optional(string, null)
    system_disk_encrypted  = optional(bool, true)
    system_disk_kms_key_id = optional(string, null)
  }))
  description = "Node attributes (required for real clusters; at least one entry)"
  default     = []
}

variable "node_groups" {
  type = list(object({
    node_group_name               = string
    node_group_type               = string
    node_count                    = number
    instance_types                = set(string)
    payment_type                  = optional(string, null)
    vswitch_ids                   = optional(set(string), [])
    with_public_ip                = optional(bool, false)
    additional_security_group_ids = optional(set(string), [])
    deployment_set_strategy       = optional(string, null)
    graceful_shutdown             = optional(bool, null)
    node_resize_strategy          = optional(string, null)
    spot_strategy                 = optional(string, null)
    spot_instance_remedy          = optional(bool, null)
    system_disk = optional(object({
      category          = string
      size              = number
      count             = optional(number, null)
      performance_level = optional(string, null)
    }), null)
    data_disks = optional(list(object({
      category          = string
      size              = number
      count             = optional(number, null)
      performance_level = optional(string, null)
    })), [])
    cost_optimized_config = optional(object({
      on_demand_base_capacity                  = number
      on_demand_percentage_above_base_capacity = number
      spot_instance_pools                      = number
    }), null)
    spot_bid_prices = optional(list(object({
      instance_type = string
      bid_price     = number
    })), [])
    subscription_config = optional(object({
      payment_duration         = number
      payment_duration_unit    = string
      auto_pay_order           = optional(bool, null)
      auto_renew               = optional(bool, null)
      auto_renew_duration      = optional(number, null)
      auto_renew_duration_unit = optional(string, null)
    }), null)
  }))
  description = "Node groups (required for real clusters; MASTER + CORE at minimum for most releases)"
  default     = []
}

variable "application_configs" {
  type = list(object({
    application_name   = string
    config_file_name   = string
    config_item_key    = string
    config_item_value  = string
    config_description = optional(string, null)
    config_scope       = optional(string, null)
    node_group_id      = optional(string, null)
    node_group_name    = optional(string, null)
  }))
  description = "Optional application configs"
  default     = []
}

variable "bootstrap_scripts" {
  type = list(object({
    script_name             = string
    script_path             = string
    script_args             = string
    execution_moment        = string
    execution_fail_strategy = string
    priority                = optional(number, null)
    node_selector = optional(list(object({
      node_select_type = string
      node_group_id    = optional(string, null)
      node_group_ids   = optional(list(string), null)
      node_group_name  = optional(string, null)
      node_group_names = optional(list(string), null)
      node_group_types = optional(list(string), null)
      node_names       = optional(list(string), null)
    })), [])
  }))
  description = "Optional bootstrap scripts"
  default     = []
}

variable "subscription_config" {
  type = object({
    payment_duration         = number
    payment_duration_unit    = string
    auto_pay_order           = optional(bool, null)
    auto_renew               = optional(bool, null)
    auto_renew_duration      = optional(number, null)
    auto_renew_duration_unit = optional(string, null)
  })
  description = "Cluster-level subscription config when PrePaid"
  default     = null
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
  description = "Additional tags"
  default     = {}
}
