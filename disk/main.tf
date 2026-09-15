locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/disk"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_ecs_disk" "this" {
  for_each = var.disks

  disk_name            = each.value.disk_name
  zone_id              = each.value.zone_id
  size                 = each.value.size
  category             = each.value.category
  performance_level    = each.value.category == "cloud_essd" ? each.value.performance_level : null
  encrypted            = each.value.encrypted
  kms_key_id           = each.value.encrypted && each.value.kms_key_id != null ? each.value.kms_key_id : null
  description          = each.value.description
  payment_type         = each.value.payment_type
  delete_auto_snapshot = each.value.delete_auto_snapshot
  delete_with_instance = each.value.delete_with_instance

  tags = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_ecs_disk_attachment" "this" {
  for_each = var.attachments

  disk_id              = alicloud_ecs_disk.this[each.value.disk_key].id
  instance_id          = each.value.instance_id
  delete_with_instance = each.value.delete_with_instance
}

resource "alicloud_ecs_auto_snapshot_policy" "this" {
  for_each = var.snapshot_policies

  auto_snapshot_policy_name = each.value.name
  repeat_weekdays           = each.value.repeat_weekdays
  time_points               = each.value.time_points
  retention_days            = each.value.retention_days

  tags = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_ecs_auto_snapshot_policy_attachment" "this" {
  for_each = var.snapshot_policy_attachments

  auto_snapshot_policy_id = alicloud_ecs_auto_snapshot_policy.this[each.value.snapshot_policy_key].id
  disk_id                 = alicloud_ecs_disk.this[each.value.disk_key].id
}

resource "alicloud_ecs_auto_snapshot_policy_attachment" "external" {
  for_each = {
    for k, v in var.disks : k => v
    if v.auto_snapshot_policy_id != null && length(trimspace(v.auto_snapshot_policy_id)) > 0
  }

  auto_snapshot_policy_id = each.value.auto_snapshot_policy_id
  disk_id                 = alicloud_ecs_disk.this[each.key].id
}
