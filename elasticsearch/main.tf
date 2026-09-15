locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/elasticsearch"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_elasticsearch_instance" "this" {
  for_each = var.instances

  version                          = each.value.version
  vswitch_id                       = each.value.vswitch_id
  password                         = each.value.password
  description                      = each.value.description
  instance_charge_type             = each.value.instance_charge_type
  period                           = each.value.instance_charge_type == "PrePaid" ? each.value.period : null
  data_node_amount                 = each.value.data_node_amount
  data_node_spec                   = each.value.data_node_spec
  data_node_disk_size              = each.value.data_node_disk_size
  data_node_disk_type              = each.value.data_node_disk_type
  data_node_disk_encrypted         = each.value.data_node_disk_encrypted
  data_node_disk_performance_level = each.value.data_node_disk_performance_level
  master_node_spec                 = each.value.master_node_spec
  master_node_disk_type            = each.value.master_node_disk_type
  client_node_amount               = each.value.client_node_amount
  client_node_spec                 = each.value.client_node_spec
  kibana_node_spec                 = each.value.kibana_node_spec
  enable_public                    = each.value.enable_public
  private_whitelist                = each.value.private_whitelist != null ? each.value.private_whitelist : var.default_private_whitelist
  public_whitelist                 = each.value.public_whitelist
  enable_kibana_public_network     = each.value.enable_kibana_public_network
  enable_kibana_private_network    = each.value.enable_kibana_private_network
  kibana_whitelist                 = each.value.kibana_whitelist
  kibana_private_whitelist         = each.value.kibana_private_whitelist != null ? each.value.kibana_private_whitelist : (each.value.private_whitelist != null ? each.value.private_whitelist : var.default_private_whitelist)
  kibana_private_security_group_id = each.value.kibana_private_security_group_id
  protocol                         = each.value.protocol
  instance_category                = each.value.instance_category
  zone_count                       = each.value.zone_count
  resource_group_id                = each.value.resource_group_id
  setting_config                   = length(each.value.setting_config) > 0 ? each.value.setting_config : null

  tags = merge(local.module_tags, var.tags, each.value.tags)
}
