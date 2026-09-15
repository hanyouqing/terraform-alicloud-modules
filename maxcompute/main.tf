locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/maxcompute"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_maxcompute_project" "this" {
  for_each = var.projects

  project_name     = coalesce(each.value.project_name, each.key)
  comment          = each.value.comment
  default_quota    = each.value.default_quota
  product_type     = each.value.product_type
  is_logical       = each.value.is_logical
  status           = each.value.status
  three_tier_model = each.value.three_tier_model
  tags             = merge(local.module_tags, var.tags, each.value.tags)

  dynamic "ip_white_list" {
    for_each = each.value.ip_white_list != null ? [each.value.ip_white_list] : []
    content {
      ip_list     = ip_white_list.value.ip_list
      vpc_ip_list = ip_white_list.value.vpc_ip_list
    }
  }

  dynamic "security_properties" {
    for_each = each.value.security_properties != null ? [each.value.security_properties] : []
    content {
      enable_download_privilege            = security_properties.value.enable_download_privilege
      label_security                       = security_properties.value.label_security
      object_creator_has_access_permission = security_properties.value.object_creator_has_access_permission
      object_creator_has_grant_permission  = security_properties.value.object_creator_has_grant_permission
      using_acl                            = security_properties.value.using_acl
      using_policy                         = security_properties.value.using_policy

      dynamic "project_protection" {
        for_each = security_properties.value.project_protection != null ? [security_properties.value.project_protection] : []
        content {
          exception_policy = project_protection.value.exception_policy
          protected        = project_protection.value.protected
        }
      }
    }
  }

  dynamic "properties" {
    for_each = each.value.properties != null ? [each.value.properties] : []
    content {
      allow_full_scan  = properties.value.allow_full_scan
      enable_decimal2  = properties.value.enable_decimal2
      enable_dr        = properties.value.enable_dr
      retention_days   = properties.value.retention_days
      sql_metering_max = properties.value.sql_metering_max
      timezone         = properties.value.timezone
      type_system      = properties.value.type_system

      dynamic "encryption" {
        for_each = properties.value.encryption != null ? [properties.value.encryption] : []
        content {
          algorithm = encryption.value.algorithm
          enable    = encryption.value.enable
          key       = encryption.value.key
        }
      }

      dynamic "table_lifecycle" {
        for_each = properties.value.table_lifecycle != null ? [properties.value.table_lifecycle] : []
        content {
          type  = table_lifecycle.value.type
          value = table_lifecycle.value.value
        }
      }
    }
  }
}
