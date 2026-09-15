variable "cluster_name" {
  type        = string
  description = "Name of the managed ACK cluster"
  default     = "ack"

  validation {
    condition     = length(var.cluster_name) >= 1 && length(var.cluster_name) <= 63
    error_message = "cluster_name must be between 1 and 63 characters."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Desired Kubernetes version (omit to use the latest available at create time)"
  default     = null
}

variable "cluster_spec" {
  type        = string
  description = "ACK managed cluster specification (ack.standard, ack.pro.small, ack.pro.xlarge, ack.pro.2xlarge, ack.pro.4xlarge)"
  default     = "ack.pro.small"

  validation {
    condition = contains([
      "ack.standard",
      "ack.pro.small",
      "ack.pro.xlarge",
      "ack.pro.2xlarge",
      "ack.pro.4xlarge"
    ], var.cluster_spec)
    error_message = "cluster_spec must be a valid ACK managed cluster specification."
  }
}

variable "worker_vswitch_ids" {
  type        = list(string)
  description = "VSwitch IDs for the control plane (mapped to provider vswitch_ids). Prefer multi-AZ."

  validation {
    condition     = length(var.worker_vswitch_ids) > 0
    error_message = "worker_vswitch_ids must contain at least one vSwitch ID."
  }
}

variable "pod_vswitch_ids" {
  type        = list(string)
  description = "VSwitch IDs for Terway pod network. Required when network_plugin is terway."
  default     = []
}

variable "network_plugin" {
  type        = string
  description = "CNI plugin: flannel (pod_cidr) or terway (pod_vswitch_ids + terway-eniip addon)"
  default     = "flannel"

  validation {
    condition     = contains(["flannel", "terway"], var.network_plugin)
    error_message = "network_plugin must be flannel or terway."
  }
}

variable "pod_cidr" {
  type        = string
  description = "Pod CIDR for Flannel. Required when network_plugin is flannel."
  default     = null
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR for the cluster"
  default     = "172.21.0.0/20"

  validation {
    condition     = can(cidrnetmask(var.service_cidr))
    error_message = "service_cidr must be valid IPv4 CIDR notation."
  }
}

variable "new_nat_gateway" {
  type        = bool
  description = "Whether ACK creates a NAT gateway during cluster creation"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable cluster deletion protection"
  default     = true
}

variable "slb_internet_enabled" {
  type        = bool
  description = "Whether to create a public SLB for the API server"
  default     = false
}

variable "load_balancer_spec" {
  type        = string
  description = "Optional API server SLB spec (deprecated in provider; retained for create-time compatibility)"
  default     = null
}

variable "proxy_mode" {
  type        = string
  description = "kube-proxy mode (iptables, ipvs, nftables)"
  default     = "ipvs"

  validation {
    condition     = contains(["iptables", "ipvs", "nftables"], var.proxy_mode)
    error_message = "proxy_mode must be iptables, ipvs, or nftables."
  }
}

variable "is_enterprise_security_group" {
  type        = bool
  description = "Whether to create an advanced (enterprise) security group for the cluster"
  default     = true
}

variable "security_group_id" {
  type        = string
  description = "Existing security group ID for cluster nodes (optional)"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID for the cluster"
  default     = null
}

variable "enable_rrsa" {
  type        = bool
  description = "Whether to enable RRSA (RAM Roles for Service Accounts)"
  default     = false
}

variable "skip_set_certificate_authority" {
  type        = bool
  description = "When true, do not persist cluster CA material on the resource (recommended)"
  default     = true
}

variable "timezone" {
  type        = string
  description = "Cluster timezone"
  default     = null
}

variable "node_cidr_mask" {
  type        = number
  description = "Node CIDR mask for Flannel (24-28)"
  default     = 24

  validation {
    condition     = var.node_cidr_mask >= 24 && var.node_cidr_mask <= 28
    error_message = "node_cidr_mask must be between 24 and 28."
  }
}

variable "addons" {
  type = list(object({
    name     = string
    config   = optional(string, null)
    version  = optional(string, null)
    disabled = optional(bool, false)
  }))
  description = "Additional create-time cluster addons. CNI addon for network_plugin is added automatically when not present."
  default     = []
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
    system_disk_size              = optional(number, 40)
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
  description = "Map of managed node pools. Prefer desired_size OR scaling_config, not both. Do not mark this map sensitive (for_each); passwords remain sensitive on the resource."
  default     = {}

  validation {
    condition = alltrue([
      for p in var.node_pools : length(p.instance_types) > 0 && length(p.vswitch_ids) > 0
    ])
    error_message = "Each node pool requires instance_types and vswitch_ids."
  }

  validation {
    condition = alltrue([
      for p in var.node_pools : p.key_name != null || p.password != null
    ])
    error_message = "Each node pool requires key_name or password."
  }

  validation {
    condition = alltrue([
      for p in var.node_pools : !(p.desired_size != null && p.scaling_config != null)
    ])
    error_message = "Use desired_size or scaling_config for a node pool, not both."
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
  description = "Additional tags merged onto the cluster"
  default     = {}
}
