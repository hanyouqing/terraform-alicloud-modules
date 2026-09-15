locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/cicd"
    Project     = var.project
    Environment = var.environment
  }

  default_cr_push_policy = jsonencode({
    Version = "1"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cr:GetAuthorizationToken",
          "cr:PullRepository",
          "cr:PushRepository",
          "cr:CreateRepository",
          "cr:GetRepository",
          "cr:ListRepository",
          "cr:GetNamespace",
          "cr:ListNamespace",
        ]
        Resource = ["*"]
      }
    ]
  })

  ci_policy_document_effective = var.ci_policy_document != null ? var.ci_policy_document : (
    var.create_ci_role ? local.default_cr_push_policy : null
  )
}

resource "alicloud_cr_namespace" "this" {
  for_each = var.namespaces

  name               = coalesce(each.value.name, each.key)
  auto_create        = each.value.auto_create
  default_visibility = each.value.default_visibility
}

resource "alicloud_cr_repo" "this" {
  for_each = var.repos

  namespace = alicloud_cr_namespace.this[each.value.namespace_key].name
  name      = coalesce(each.value.name, each.key)
  summary   = each.value.summary
  repo_type = each.value.repo_type
  detail    = each.value.detail
}

resource "alicloud_ecs_image_pipeline" "this" {
  for_each = var.image_pipelines

  base_image                 = each.value.base_image
  base_image_type            = each.value.base_image_type
  name                       = coalesce(each.value.name, each.key)
  image_name                 = each.value.image_name
  description                = each.value.description
  build_content              = each.value.build_content
  vswitch_id                 = each.value.vswitch_id
  instance_type              = each.value.instance_type
  system_disk_size           = each.value.system_disk_size
  internet_max_bandwidth_out = each.value.internet_max_bandwidth_out
  delete_instance_on_failure = each.value.delete_instance_on_failure
  to_region_id               = length(each.value.to_region_id) > 0 ? each.value.to_region_id : null
  add_account                = length(each.value.add_account) > 0 ? each.value.add_account : null
  resource_group_id          = each.value.resource_group_id
  tags                       = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_ram_role" "ci" {
  count = var.create_ci_role ? 1 : 0

  role_name                   = var.ci_role_name
  assume_role_policy_document = var.ci_assume_role_policy_document
  description                 = var.ci_role_description
  max_session_duration        = var.ci_max_session_duration
  tags                        = merge(local.module_tags, var.tags)

  lifecycle {
    precondition {
      condition     = var.ci_role_name != null && var.ci_role_name != ""
      error_message = "create_ci_role requires ci_role_name."
    }
    precondition {
      condition     = var.ci_assume_role_policy_document != null && var.ci_assume_role_policy_document != ""
      error_message = "create_ci_role requires ci_assume_role_policy_document."
    }
  }
}

resource "alicloud_ram_policy" "ci" {
  count = var.create_ci_role && local.ci_policy_document_effective != null ? 1 : 0

  policy_name     = coalesce(var.ci_policy_name, "${var.ci_role_name}-cr-push")
  policy_document = local.ci_policy_document_effective
  description     = var.ci_policy_description
}

resource "alicloud_ram_role_policy_attachment" "ci_custom" {
  count = length(alicloud_ram_policy.ci)

  role_name   = alicloud_ram_role.ci[0].role_name
  policy_name = alicloud_ram_policy.ci[0].policy_name
  policy_type = "Custom"
}

resource "alicloud_ram_role_policy_attachment" "ci_extra" {
  for_each = var.create_ci_role ? var.ci_attach_system_policies : {}

  role_name   = alicloud_ram_role.ci[0].role_name
  policy_name = each.value.policy_name
  policy_type = each.value.policy_type
}
