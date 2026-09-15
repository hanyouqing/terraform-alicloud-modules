locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/sls"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  stores_with_index = {
    for k, v in var.log_stores : k => v if v.create_index
  }
}

resource "alicloud_log_project" "this" {
  project_name      = var.project_name
  description       = var.description
  resource_group_id = var.resource_group_id
  tags              = local.common_tags
}

resource "alicloud_log_store" "this" {
  for_each = var.log_stores

  project_name          = alicloud_log_project.this.project_name
  logstore_name         = coalesce(each.value.logstore_name, each.key)
  retention_period      = each.value.retention_period
  shard_count           = each.value.shard_count
  auto_split            = each.value.auto_split
  max_split_shard_count = each.value.auto_split ? each.value.max_split_shard_count : null
  append_meta           = each.value.append_meta
  enable_web_tracking   = each.value.enable_web_tracking
}

resource "alicloud_log_store_index" "this" {
  for_each = local.stores_with_index

  project  = alicloud_log_project.this.project_name
  logstore = alicloud_log_store.this[each.key].logstore_name

  dynamic "full_text" {
    for_each = each.value.full_text != null ? [each.value.full_text] : [{
      case_sensitive  = false
      include_chinese = false
      token           = ", '\";=()[]{}?@&<>/:\\n\\t\\r"
    }]
    content {
      case_sensitive  = full_text.value.case_sensitive
      include_chinese = full_text.value.include_chinese
      token           = full_text.value.token
    }
  }

  dynamic "field_search" {
    for_each = each.value.field_search
    content {
      name             = field_search.value.name
      type             = field_search.value.type
      alias            = field_search.value.alias
      case_sensitive   = field_search.value.case_sensitive
      include_chinese  = field_search.value.include_chinese
      token            = field_search.value.token
      enable_analytics = field_search.value.enable_analytics
    }
  }
}
