locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/adb"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_adb_db_cluster_lake_version" "this" {
  for_each = var.clusters

  db_cluster_version            = each.value.db_cluster_version
  payment_type                  = each.value.payment_type
  vpc_id                        = each.value.vpc_id
  vswitch_id                    = each.value.vswitch_id
  zone_id                       = each.value.zone_id
  db_cluster_description        = each.value.db_cluster_description
  compute_resource              = each.value.compute_resource
  storage_resource              = each.value.storage_resource
  disk_encryption               = each.value.disk_encryption
  enable_ssl                    = each.value.enable_ssl
  kms_id                        = each.value.kms_id
  security_ips                  = join(",", coalesce(each.value.security_ips, var.default_security_ips))
  period                        = each.value.period
  product_form                  = each.value.product_form
  product_version               = each.value.product_version
  reserved_node_count           = each.value.reserved_node_count
  reserved_node_size            = each.value.reserved_node_size
  resource_group_id             = each.value.resource_group_id
  enable_default_resource_group = each.value.enable_default_resource_group
  secondary_vswitch_id          = each.value.secondary_vswitch_id
  secondary_zone_id             = each.value.secondary_zone_id
  backup_set_id                 = each.value.backup_set_id
  restore_to_time               = each.value.restore_to_time
  restore_type                  = each.value.restore_type
  source_db_cluster_id          = each.value.source_db_cluster_id
}

resource "alicloud_adb_lake_account" "this" {
  for_each = var.accounts

  db_cluster_id       = alicloud_adb_db_cluster_lake_version.this[each.value.cluster_key].id
  account_name        = coalesce(each.value.account_name, each.key)
  account_password    = each.value.account_password
  account_type        = each.value.account_type
  account_description = each.value.account_description
  ram_user_list       = length(each.value.ram_user_list) > 0 ? each.value.ram_user_list : null
}
