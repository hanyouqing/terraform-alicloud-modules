locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/kms"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  alias_name_normalized = var.create_alias && var.alias_name != null ? (
    startswith(var.alias_name, "alias/") ? var.alias_name : "alias/${var.alias_name}"
  ) : null
}

resource "alicloud_kms_key" "this" {
  description            = var.description
  pending_window_in_days = var.pending_window_in_days
  protection_level       = var.protection_level
  key_usage              = var.key_usage
  key_spec               = var.key_spec
  automatic_rotation     = var.automatic_rotation
  rotation_interval      = var.automatic_rotation == "Enabled" ? var.rotation_interval : null
  status                 = var.status
  dkms_instance_id       = var.dkms_instance_id
  policy                 = var.policy
  tags                   = local.common_tags
}

resource "alicloud_kms_alias" "this" {
  count = var.create_alias ? 1 : 0

  alias_name = local.alias_name_normalized
  key_id     = alicloud_kms_key.this.id
}

resource "alicloud_kms_secret" "this" {
  for_each = var.secrets

  secret_name                   = each.key
  secret_data                   = each.value.secret_data
  version_id                    = each.value.version_id
  description                   = each.value.description
  secret_type                   = each.value.secret_type
  version_stages                = each.value.version_stages
  encryption_key_id             = coalesce(each.value.encryption_key_id, alicloud_kms_key.this.id)
  force_delete_without_recovery = each.value.force_delete_without_recovery
  recovery_window_in_days       = each.value.force_delete_without_recovery ? null : each.value.recovery_window_in_days
  tags                          = local.common_tags
}
