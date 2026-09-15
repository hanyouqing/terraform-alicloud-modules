locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/cdn"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  domain_configs = {
    for pair in flatten([
      for domain_key, domain in var.domains : [
        for cfg_key, cfg in domain.configs : {
          key = "${domain_key}:${cfg_key}"
          value = merge(cfg, {
            domain_key  = domain_key
            domain_name = coalesce(domain.domain_name, domain_key)
          })
        }
      ]
    ]) : pair.key => pair.value
  }
}

resource "alicloud_cdn_domain_new" "this" {
  for_each = var.domains

  domain_name       = coalesce(each.value.domain_name, each.key)
  cdn_type          = each.value.cdn_type
  scope             = each.value.scope
  resource_group_id = each.value.resource_group_id
  tags              = local.common_tags

  dynamic "sources" {
    for_each = each.value.sources
    content {
      type     = sources.value.type
      content  = sources.value.content
      port     = sources.value.port
      priority = sources.value.priority
      weight   = sources.value.weight
    }
  }
}

resource "alicloud_cdn_domain_config" "this" {
  for_each = local.domain_configs

  domain_name   = alicloud_cdn_domain_new.this[each.value.domain_key].domain_name
  function_name = each.value.function_name
  parent_id     = each.value.parent_id

  dynamic "function_args" {
    for_each = each.value.function_args
    content {
      arg_name  = function_args.value.arg_name
      arg_value = function_args.value.arg_value
    }
  }
}
