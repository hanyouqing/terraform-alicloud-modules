locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/rds"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_db_instance" "this" {
  for_each = var.instances

  engine                   = each.value.engine
  engine_version           = each.value.engine_version
  instance_type            = each.value.instance_type
  instance_storage         = each.value.instance_storage
  instance_name            = each.value.instance_name
  vswitch_id               = each.value.vswitch_id
  zone_id                  = each.value.zone_id
  zone_id_slave_a          = each.value.zone_id_slave_a
  instance_charge_type     = each.value.instance_charge_type
  period                   = each.value.instance_charge_type == "Prepaid" ? each.value.period : null
  auto_renew               = each.value.instance_charge_type == "Prepaid" ? each.value.auto_renew : null
  db_instance_storage_type = each.value.db_instance_storage_type
  category                 = each.value.category
  security_ips             = each.value.security_ips != null ? each.value.security_ips : var.default_security_ips
  security_group_ids       = length(each.value.security_group_ids) > 0 ? each.value.security_group_ids : null
  ssl_action               = each.value.ssl_action
  encryption_key           = each.value.encryption_key
  tde_status               = each.value.tde_status
  deletion_protection      = each.value.deletion_protection
  force_restart            = each.value.force_restart

  tags = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_db_backup_policy" "this" {
  for_each = var.instances

  instance_id                 = alicloud_db_instance.this[each.key].id
  preferred_backup_period     = each.value.backup.preferred_backup_period
  preferred_backup_time       = each.value.backup.preferred_backup_time
  backup_retention_period     = each.value.backup.backup_retention_period
  enable_backup_log           = each.value.backup.enable_backup_log
  log_backup_retention_period = each.value.backup.log_backup_retention_period
}

resource "alicloud_rds_account" "this" {
  for_each = var.accounts

  db_instance_id      = alicloud_db_instance.this[each.value.instance_key].id
  account_name        = each.value.account_name
  account_password    = each.value.account_password
  account_type        = each.value.account_type
  account_description = each.value.account_description
}
