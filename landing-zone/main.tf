locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/landing-zone"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  top_level = var.enable_default_structure ? {
    core = {
      folder_name      = var.folder_names.core
      parent_folder_id = null
    }
    infrastructure = {
      folder_name      = var.folder_names.infrastructure
      parent_folder_id = null
    }
    security = {
      folder_name      = var.folder_names.security
      parent_folder_id = null
    }
    workloads = {
      folder_name      = var.folder_names.workloads
      parent_folder_id = null
    }
  } : {}

  workload_children = var.enable_default_structure && var.enable_workload_children ? {
    workloads_production = {
      folder_name = var.folder_names.production
      parent_key  = "workloads"
    }
    workloads_non_production = {
      folder_name = var.folder_names.non_production
      parent_key  = "workloads"
    }
  } : {}

  deny_leave_document = jsonencode({
    Version = "1"
    Statement = [{
      Effect   = "Deny"
      Action   = ["resourcemanager:LeaveResourceDirectory"]
      Resource = ["*"]
    }]
  })

  protect_rd_role_document = jsonencode({
    Version = "1"
    Statement = [{
      Effect = "Deny"
      Action = [
        "ram:UpdateRole",
        "ram:DeleteRole",
        "ram:AttachPolicyToRole",
        "ram:DetachPolicyFromRole"
      ]
      Resource = ["acs:ram:*:*:role/ResourceDirectoryAccountAccessRole"]
    }]
  })

  baseline_policies = var.create_baseline_policies ? merge(
    var.enable_deny_leave_organization ? {
      deny_leave_organization = {
        control_policy_name = "DenyLeaveOrganization"
        description         = "Deny members leaving the Resource Directory"
        policy_document     = local.deny_leave_document
      }
    } : {},
    var.enable_protect_rd_access_role ? {
      protect_rd_access_role = {
        control_policy_name = "ProtectResourceDirectoryAccountAccessRole"
        description         = "Protect ResourceDirectoryAccountAccessRole from mutation"
        policy_document     = local.protect_rd_role_document
      }
    } : {}
  ) : {}

  primary_folder_ids = merge(
    { for k, v in alicloud_resource_manager_folder.top : k => v.id },
    { for k, v in alicloud_resource_manager_folder.workload_child : k => v.id }
  )

  folder_ids = merge(
    local.primary_folder_ids,
    { for k, v in alicloud_resource_manager_folder.additional : k => v.id }
  )

  baseline_attach_targets = {
    for pair in setproduct(keys(local.baseline_policies), var.baseline_attach_folder_keys) :
    "${pair[0]}__${pair[1]}" => {
      policy_key = pair[0]
      folder_key = pair[1]
    }
    if contains(keys(local.folder_ids), pair[1])
  }

  delegated_admin_resolved = {
    for k, v in var.delegated_administrators : k => {
      account_id = v.account_id != null ? v.account_id : (
        v.account_key != null ? alicloud_resource_manager_account.member[v.account_key].id : null
      )
      service_principal = v.service_principal
    }
  }
}

resource "alicloud_resource_manager_resource_directory" "this" {
  count = var.create_resource_directory ? 1 : 0
}

resource "alicloud_resource_manager_folder" "top" {
  for_each = local.top_level

  folder_name = each.value.folder_name
  tags        = local.common_tags

  depends_on = [alicloud_resource_manager_resource_directory.this]
}

resource "alicloud_resource_manager_folder" "workload_child" {
  for_each = local.workload_children

  folder_name      = each.value.folder_name
  parent_folder_id = alicloud_resource_manager_folder.top[each.value.parent_key].id
  tags             = local.common_tags
}

resource "alicloud_resource_manager_folder" "additional" {
  for_each = var.additional_folders

  folder_name = each.value.folder_name
  parent_folder_id = each.value.parent_folder_id != null ? each.value.parent_folder_id : (
    each.value.parent_folder_key != null ? local.primary_folder_ids[each.value.parent_folder_key] : null
  )
  tags = local.common_tags
}

resource "alicloud_resource_manager_account" "member" {
  for_each = var.member_accounts

  display_name        = each.value.display_name
  folder_id           = local.folder_ids[each.value.folder_key]
  payer_account_id    = each.value.payer_account_id
  account_name_prefix = each.value.account_name_prefix
  tags                = local.common_tags

  depends_on = [
    alicloud_resource_manager_folder.top,
    alicloud_resource_manager_folder.workload_child,
    alicloud_resource_manager_folder.additional
  ]
}

resource "alicloud_resource_manager_control_policy" "baseline" {
  for_each = local.baseline_policies

  control_policy_name = each.value.control_policy_name
  description         = each.value.description
  effect_scope        = var.baseline_policy_effect_scope
  policy_document     = each.value.policy_document
  tags                = local.common_tags

  depends_on = [alicloud_resource_manager_resource_directory.this]
}

resource "alicloud_resource_manager_control_policy_attachment" "baseline" {
  for_each = local.baseline_attach_targets

  policy_id = alicloud_resource_manager_control_policy.baseline[each.value.policy_key].id
  target_id = local.folder_ids[each.value.folder_key]
}

resource "alicloud_resource_manager_delegated_administrator" "this" {
  for_each = local.delegated_admin_resolved

  account_id        = each.value.account_id
  service_principal = each.value.service_principal

  depends_on = [alicloud_resource_manager_account.member]
}
