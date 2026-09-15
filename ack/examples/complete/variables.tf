variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "cluster_name" {
  type        = string
  description = "ACK cluster name"
  default     = "complete-ack"
}

variable "kubernetes_version" {
  type        = string
  description = "Optional Kubernetes version"
  default     = null
}

variable "cluster_spec" {
  type        = string
  description = "ACK cluster specification"
  default     = "ack.pro.small"
}

variable "worker_vswitch_ids" {
  type        = list(string)
  description = "Control-plane vSwitch IDs"
}

variable "pod_vswitch_ids" {
  type        = list(string)
  description = "Terway pod vSwitch IDs"
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR"
  default     = "172.21.0.0/20"
}

variable "deletion_protection" {
  type        = bool
  description = "Cluster deletion protection"
  default     = true
}

variable "resource_group_id" {
  type        = string
  description = "Optional resource group ID"
  default     = null
}

variable "node_pools" {
  type = map(object({
    instance_types                = list(string)
    vswitch_ids                   = list(string)
    desired_size                  = optional(number, null)
    key_name                      = optional(string, null)
    password                      = optional(string, null)
    install_cloud_monitor         = optional(bool, true)
    system_disk_category          = optional(string, "cloud_essd")
    system_disk_size              = optional(number, 80)
    system_disk_encrypted         = optional(bool, true)
    system_disk_performance_level = optional(string, "PL0")
    image_type                    = optional(string, null)
    instance_charge_type          = optional(string, "PostPaid")
    scaling_config = optional(object({
      min_size = number
      max_size = number
      type     = optional(string, null)
      enable   = optional(bool, true)
    }), null)
    data_disks = optional(list(object({
      category          = optional(string, "cloud_essd")
      size              = number
      encrypted         = optional(bool, true)
      performance_level = optional(string, "PL0")
    })), [])
    labels = optional(map(string), {})
    tags   = optional(map(string), {})
  }))
  description = "Node pools (use desired_size or scaling_config)"
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
