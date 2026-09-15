locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/resource-group"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_resource_manager_resource_group" "this" {
  for_each = var.resource_groups

  display_name        = each.value.display_name
  resource_group_name = coalesce(each.value.resource_group_name, each.key)
  tags                = merge(local.common_tags, each.value.tags)
}
