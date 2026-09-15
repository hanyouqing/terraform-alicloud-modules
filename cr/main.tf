locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/cr"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  ee_enabled = var.create_ee_instance || (var.ee_instance_id != null && var.ee_instance_id != "")

  ee_instance_id_effective = var.create_ee_instance ? (
    alicloud_cr_ee_instance.this[0].id
  ) : var.ee_instance_id

  personal_enabled = !local.ee_enabled
}

resource "alicloud_cr_ee_instance" "this" {
  count = var.create_ee_instance ? 1 : 0

  instance_name     = var.ee_instance_name
  instance_type     = var.ee_instance_type
  payment_type      = var.ee_payment_type
  period            = var.ee_period
  renewal_status    = var.ee_renewal_status
  renew_period      = var.ee_renewal_status == "AutoRenewal" ? var.ee_renew_period : null
  password          = var.ee_password
  resource_group_id = var.ee_resource_group_id
  image_scanner     = var.ee_image_scanner
  tags              = local.common_tags

  lifecycle {
    precondition {
      condition     = var.ee_instance_name != null && var.ee_instance_name != ""
      error_message = "create_ee_instance requires ee_instance_name."
    }
  }
}

resource "alicloud_cr_namespace" "this" {
  for_each = local.personal_enabled ? var.namespaces : {}

  name               = coalesce(each.value.name, each.key)
  auto_create        = each.value.auto_create
  default_visibility = each.value.default_visibility
}

resource "alicloud_cr_repo" "this" {
  for_each = local.personal_enabled ? var.repos : {}

  namespace = alicloud_cr_namespace.this[each.value.namespace_key].name
  name      = coalesce(each.value.name, each.key)
  summary   = each.value.summary
  repo_type = each.value.repo_type
  detail    = each.value.detail
}

resource "alicloud_cr_ee_namespace" "this" {
  for_each = local.ee_enabled ? var.namespaces : {}

  instance_id        = local.ee_instance_id_effective
  name               = coalesce(each.value.name, each.key)
  auto_create        = each.value.auto_create
  default_visibility = each.value.default_visibility
}

resource "alicloud_cr_ee_repo" "this" {
  for_each = local.ee_enabled ? var.repos : {}

  instance_id = local.ee_instance_id_effective
  namespace   = alicloud_cr_ee_namespace.this[each.value.namespace_key].name
  name        = coalesce(each.value.name, each.key)
  summary     = each.value.summary
  repo_type   = each.value.repo_type
  detail      = each.value.detail
}

resource "alicloud_cr_endpoint_acl_policy" "this" {
  for_each = local.ee_enabled ? var.endpoint_acl_policies : {}

  instance_id   = local.ee_instance_id_effective
  entry         = each.value.entry
  endpoint_type = each.value.endpoint_type
  module_name   = each.value.module_name
  description   = coalesce(each.value.description, each.key)

  lifecycle {
    precondition {
      condition     = local.ee_instance_id_effective != null && local.ee_instance_id_effective != ""
      error_message = "endpoint_acl_policies require an EE instance (create_ee_instance or ee_instance_id)."
    }
  }
}
