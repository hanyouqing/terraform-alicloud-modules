locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/hologram"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_hologram_instance" "this" {
  for_each = var.instances

  instance_name      = coalesce(each.value.instance_name, each.key)
  instance_type      = each.value.instance_type
  payment_type       = each.value.payment_type
  zone_id            = each.value.zone_id
  auto_pay           = each.value.auto_pay
  cold_storage_size  = each.value.cold_storage_size
  cpu                = each.value.cpu
  duration           = each.value.duration
  enable_ssl         = each.value.enable_ssl
  gateway_count      = each.value.gateway_count
  initial_databases  = each.value.initial_databases
  leader_instance_id = each.value.leader_instance_id
  pricing_cycle      = each.value.pricing_cycle
  resource_group_id  = each.value.resource_group_id
  scale_type         = each.value.scale_type
  status             = each.value.status
  storage_size       = each.value.storage_size
  tags               = merge(local.module_tags, var.tags, each.value.tags)

  dynamic "endpoints" {
    for_each = each.value.endpoints
    content {
      type       = endpoints.value.type
      vpc_id     = endpoints.value.vpc_id
      vswitch_id = endpoints.value.vswitch_id
    }
  }
}
