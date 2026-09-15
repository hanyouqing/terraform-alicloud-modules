variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "default_private_whitelist" {
  type        = list(string)
  description = "Default private whitelist (VPC CIDR)"
  default     = ["10.0.0.0/16"]
}

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
  description = "Production-oriented Elasticsearch instances (PostPaid examples; encrypted disks; Kibana private)"
  default = {
    search = {
      version                       = "7.10_with_X-Pack"
      vswitch_id                    = "vsw-xxxxxxxx"
      password                      = null
      description                   = "prod-search"
      instance_charge_type          = "PostPaid"
      data_node_amount              = 2
      data_node_spec                = "elasticsearch.sn2ne.large"
      data_node_disk_size           = 40
      data_node_disk_type           = "cloud_essd"
      data_node_disk_encrypted      = true
      enable_public                 = false
      private_whitelist             = ["10.0.0.0/16"]
      enable_kibana_public_network  = false
      enable_kibana_private_network = true
      kibana_private_whitelist      = ["10.0.0.0/16"]
    }
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
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
