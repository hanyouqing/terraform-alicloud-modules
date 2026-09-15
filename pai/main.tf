locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/pai"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_pai_workspace_workspace" "this" {
  workspace_name    = var.workspace_name
  description       = var.description
  env_types         = var.env_types
  display_name      = var.display_name
  resource_group_id = var.resource_group_id
}

resource "alicloud_pai_workspace_dataset" "this" {
  for_each = var.datasets

  workspace_id     = alicloud_pai_workspace_workspace.this.id
  dataset_name     = coalesce(each.value.dataset_name, each.key)
  data_source_type = each.value.data_source_type
  property         = each.value.property
  uri              = each.value.uri
  accessibility    = each.value.accessibility
  data_type        = each.value.data_type
  description      = each.value.description
  options          = each.value.options
  source_id        = each.value.source_id
  source_type      = each.value.source_type

  dynamic "labels" {
    for_each = each.value.labels
    content {
      key   = labels.value.key
      value = labels.value.value
    }
  }
}

resource "alicloud_pai_workspace_model" "this" {
  for_each = var.models

  workspace_id      = alicloud_pai_workspace_workspace.this.id
  model_name        = coalesce(each.value.model_name, each.key)
  accessibility     = each.value.accessibility
  domain            = each.value.domain
  extra_info        = length(each.value.extra_info) > 0 ? each.value.extra_info : null
  model_description = each.value.model_description
  model_doc         = each.value.model_doc
  model_type        = each.value.model_type
  order_number      = each.value.order_number
  origin            = each.value.origin
  task              = each.value.task

  dynamic "labels" {
    for_each = each.value.labels
    content {
      key   = labels.value.key
      value = labels.value.value
    }
  }
}

resource "alicloud_pai_service" "this" {
  for_each = var.services

  workspace_id   = alicloud_pai_workspace_workspace.this.id
  service_config = each.value.service_config
  develop        = each.value.develop
  status         = each.value.status
  tags           = merge(local.module_tags, var.tags, each.value.tags)
}
