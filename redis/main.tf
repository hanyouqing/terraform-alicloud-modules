locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/redis"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_kvstore_instance" "this" {
  for_each = toset(nonsensitive(keys(var.instances)))

  db_instance_name    = var.instances[each.key].db_instance_name
  vswitch_id          = var.instances[each.key].vswitch_id
  instance_class      = var.instances[each.key].instance_class
  instance_type       = var.instances[each.key].instance_type
  engine_version      = var.instances[each.key].engine_version
  password            = var.instances[each.key].password
  zone_id             = var.instances[each.key].zone_id
  secondary_zone_id   = var.instances[each.key].secondary_zone_id
  payment_type        = var.instances[each.key].payment_type
  period              = var.instances[each.key].payment_type == "PrePaid" ? var.instances[each.key].period : null
  auto_renew          = var.instances[each.key].payment_type == "PrePaid" ? var.instances[each.key].auto_renew : null
  ssl_enable          = var.instances[each.key].ssl_enable
  vpc_auth_mode       = var.instances[each.key].vpc_auth_mode
  security_ips        = var.instances[each.key].security_ips != null ? var.instances[each.key].security_ips : var.default_security_ips
  security_group_id   = var.instances[each.key].security_group_id
  maintain_start_time = var.instances[each.key].maintain_start_time
  maintain_end_time   = var.instances[each.key].maintain_end_time
  backup_period       = var.instances[each.key].backup_period
  backup_time         = var.instances[each.key].backup_time
  config              = length(var.instances[each.key].config) > 0 ? var.instances[each.key].config : null

  tags = merge(local.module_tags, var.tags, var.instances[each.key].tags)
}
