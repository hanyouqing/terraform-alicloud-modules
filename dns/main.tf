locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/dns"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  public_record_domain = {
    for k, v in var.records : k => (
      v.domain_key != null ? alicloud_alidns_domain.this[v.domain_key].domain_name : coalesce(v.domain_name, var.domain_name)
    )
  }
}

resource "alicloud_alidns_domain" "this" {
  for_each = var.domains

  domain_name       = coalesce(each.value.domain_name, each.key)
  group_id          = each.value.group_id
  resource_group_id = each.value.resource_group_id
  remark            = each.value.remark
  lang              = each.value.lang
  tags              = local.common_tags
}

resource "alicloud_alidns_record" "this" {
  for_each = var.records

  domain_name = local.public_record_domain[each.key]
  rr          = each.value.rr
  type        = each.value.type
  value       = each.value.value
  ttl         = each.value.ttl
  line        = each.value.line
  priority    = each.value.priority
  status      = each.value.status
  remark      = each.value.remark
  lang        = each.value.lang

  lifecycle {
    precondition {
      condition     = local.public_record_domain[each.key] != null && local.public_record_domain[each.key] != ""
      error_message = "Each records entry requires domain_key, domain_name, or module-level domain_name."
    }
  }
}

resource "alicloud_pvtz_zone" "this" {
  for_each = var.private_zones

  zone_name         = coalesce(each.value.zone_name, each.key)
  remark            = each.value.remark
  proxy_pattern     = each.value.proxy_pattern
  resource_group_id = each.value.resource_group_id
  lang              = each.value.lang
  tags              = local.common_tags
}

resource "alicloud_pvtz_zone_record" "this" {
  for_each = var.private_zone_records

  zone_id  = alicloud_pvtz_zone.this[each.value.zone_key].id
  rr       = each.value.rr
  type     = each.value.type
  value    = each.value.value
  ttl      = each.value.ttl
  priority = each.value.priority
  status   = each.value.status
  remark   = each.value.remark
  lang     = each.value.lang
}

resource "alicloud_pvtz_zone_attachment" "this" {
  for_each = {
    for k, v in var.private_zones : k => v if length(v.vpc_ids) > 0
  }

  zone_id = alicloud_pvtz_zone.this[each.key].id
  vpc_ids = each.value.vpc_ids
  lang    = each.value.lang
}
