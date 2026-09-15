locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/resource-directory"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  folders_root = {
    for k, v in var.folders : k => v
    if v.parent_folder_key == null && v.parent_folder_id == null
  }

  folders_child = {
    for k, v in var.folders : k => v
    if v.parent_folder_key != null || v.parent_folder_id != null
  }

  folder_ids = merge(
    { for k, v in alicloud_resource_manager_folder.root : k => v.id },
    { for k, v in alicloud_resource_manager_folder.child : k => v.id }
  )
}

resource "alicloud_resource_manager_resource_directory" "this" {
  count = var.create_resource_directory ? 1 : 0
}

resource "alicloud_resource_manager_folder" "root" {
  for_each = local.folders_root

  folder_name = each.value.folder_name
  tags        = merge(local.common_tags, each.value.tags)

  depends_on = [alicloud_resource_manager_resource_directory.this]
}

resource "alicloud_resource_manager_folder" "child" {
  for_each = local.folders_child

  folder_name = each.value.folder_name
  parent_folder_id = (
    each.value.parent_folder_key != null
    ? alicloud_resource_manager_folder.root[each.value.parent_folder_key].id
    : each.value.parent_folder_id
  )
  tags = merge(local.common_tags, each.value.tags)

  depends_on = [alicloud_resource_manager_folder.root]
}

resource "alicloud_resource_manager_account" "this" {
  for_each = var.accounts

  display_name = each.value.display_name
  folder_id = (
    each.value.folder_key != null
    ? local.folder_ids[each.value.folder_key]
    : each.value.folder_id
  )
  payer_account_id    = each.value.payer_account_id
  account_name_prefix = each.value.account_name_prefix
  tags                = merge(local.common_tags, each.value.tags)

  depends_on = [
    alicloud_resource_manager_resource_directory.this,
    alicloud_resource_manager_folder.root,
    alicloud_resource_manager_folder.child
  ]
}

resource "alicloud_resource_manager_control_policy" "this" {
  for_each = var.control_policies

  control_policy_name = each.value.control_policy_name
  effect_scope        = each.value.effect_scope
  policy_document     = each.value.policy_document
  description         = each.value.description
  tags                = merge(local.common_tags, each.value.tags)

  depends_on = [alicloud_resource_manager_resource_directory.this]
}

resource "alicloud_resource_manager_control_policy_attachment" "this" {
  for_each = var.control_policy_attachments

  policy_id = alicloud_resource_manager_control_policy.this[each.value.policy_key].id
  target_id = (
    each.value.target_id != null
    ? each.value.target_id
    : each.value.target_folder_key != null
    ? local.folder_ids[each.value.target_folder_key]
    : alicloud_resource_manager_account.this[each.value.target_account_key].id
  )
}

resource "alicloud_resource_manager_delegated_administrator" "this" {
  for_each = var.delegated_administrators

  account_id        = alicloud_resource_manager_account.this[each.value.account_key].id
  service_principal = each.value.service_principal
}
