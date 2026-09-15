locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/actiontrail"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_actiontrail_trail" "this" {
  for_each = var.trails

  trail_name            = coalesce(each.value.trail_name, each.key)
  oss_bucket_name       = each.value.oss_bucket_name
  oss_key_prefix        = each.value.oss_key_prefix
  oss_write_role_arn    = each.value.oss_write_role_arn
  sls_project_arn       = each.value.sls_project_arn
  sls_write_role_arn    = each.value.sls_write_role_arn
  event_rw              = each.value.event_rw
  trail_region          = each.value.trail_region
  status                = each.value.status
  is_organization_trail = each.value.is_organization_trail
}
