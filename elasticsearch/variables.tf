variable "instances" {
  type = map(object({
    version                          = string
    vswitch_id                       = string
    password                         = optional(string, null)
    description                      = optional(string, null)
    instance_charge_type             = optional(string, "PostPaid")
    period                           = optional(number, null)
    data_node_amount                 = optional(number, 2)
    data_node_spec                   = optional(string, "elasticsearch.sn2ne.large")
    data_node_disk_size              = optional(number, 20)
    data_node_disk_type              = optional(string, "cloud_ssd")
    data_node_disk_encrypted         = optional(bool, true)
    data_node_disk_performance_level = optional(string, null)
    master_node_spec                 = optional(string, null)
    master_node_disk_type            = optional(string, null)
    client_node_amount               = optional(number, null)
    client_node_spec                 = optional(string, null)
    kibana_node_spec                 = optional(string, null)
    enable_public                    = optional(bool, false)
    private_whitelist                = optional(list(string), null)
    public_whitelist                 = optional(list(string), null)
    enable_kibana_public_network     = optional(bool, false)
    enable_kibana_private_network    = optional(bool, true)
    kibana_whitelist                 = optional(list(string), null)
    kibana_private_whitelist         = optional(list(string), null)
    kibana_private_security_group_id = optional(string, null)
    protocol                         = optional(string, null)
    instance_category                = optional(string, null)
    zone_count                       = optional(number, null)
    resource_group_id                = optional(string, null)
    setting_config                   = optional(map(string), {})
    tags                             = optional(map(string), {})
  }))
  description = "Map of Elasticsearch instances. Required per entry: version, vswitch_id. Password is assigned on the resource (provider-sensitive); the map itself is not marked sensitive."
  default     = {}

  validation {
    condition = alltrue([
      for i in var.instances : contains(["PostPaid", "PrePaid"], i.instance_charge_type)
    ])
    error_message = "instance_charge_type must be PostPaid or PrePaid."
  }

  validation {
    condition = alltrue([
      for i in var.instances : i.data_node_amount == null || i.data_node_amount >= 1
    ])
    error_message = "data_node_amount must be >= 1 when set."
  }
}

variable "default_private_whitelist" {
  type        = list(string)
  description = "Default private_whitelist when an instance omits private_whitelist (prefer VPC CIDR)"
  default     = ["10.0.0.0/8"]
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
  description = "Additional tags applied to all instances"
  default     = {}
}
