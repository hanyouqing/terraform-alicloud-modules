locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/dataworks"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_data_works_project" "this" {
  count = var.create_project ? 1 : 0

  display_name            = var.display_name
  project_name            = var.project_name
  pai_task_enabled        = var.pai_task_enabled
  description             = var.description
  dev_environment_enabled = var.dev_environment_enabled
  dev_role_disabled       = var.dev_role_disabled
  resource_group_id       = var.resource_group_id
  status                  = var.status

  tags = merge(local.module_tags, var.tags)

  lifecycle {
    precondition {
      condition     = !var.create_project || (var.display_name != null && var.project_name != null)
      error_message = "create_project requires display_name and project_name."
    }
  }
}

resource "alicloud_data_works_dw_resource_group" "this" {
  for_each = var.dw_resource_groups

  default_vpc_id        = each.value.default_vpc_id
  default_vswitch_id    = each.value.default_vswitch_id
  remark                = each.value.remark
  resource_group_name   = coalesce(each.value.resource_group_name, each.key)
  payment_type          = each.value.payment_type
  payment_duration      = each.value.payment_duration
  payment_duration_unit = each.value.payment_duration_unit
  auto_renew            = each.value.auto_renew
  specification         = each.value.specification
  resource_group_id     = each.value.resource_group_id

  tags = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_data_works_project_member" "this" {
  for_each = var.create_project ? var.project_members : {}

  project_id = tonumber(alicloud_data_works_project.this[0].id)
  user_id    = each.value.user_id

  dynamic "roles" {
    for_each = each.value.roles
    content {
      code = roles.value.code
    }
  }
}
