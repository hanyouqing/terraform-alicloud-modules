variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "cluster_name" {
  type        = string
  description = "EMR cluster name"
  default     = "demo-emr"
}

variable "release_version" {
  type        = string
  description = "EMR release version"
  default     = "EMR-5.10.0"
}

variable "applications" {
  type        = set(string)
  description = "EMR applications"
  default     = ["SPARK", "HIVE", "HDFS", "YARN"]
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
  description = "Node attributes"
}

variable "node_groups" {
  type = list(object({
    node_group_name = string
    node_group_type = string
    node_count      = number
    instance_types  = set(string)
    payment_type    = optional(string, "PayAsYouGo")
    vswitch_ids     = optional(set(string), [])
    with_public_ip  = optional(bool, false)
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
  }))
  description = "Node groups (MASTER + CORE)"
}
