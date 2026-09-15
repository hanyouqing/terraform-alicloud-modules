locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/cen"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_cen_instance" "this" {
  cen_instance_name = var.cen_instance_name
  description       = var.description
  protection_level  = var.protection_level
  resource_group_id = var.resource_group_id
  tags              = local.common_tags
}

resource "alicloud_cen_instance_attachment" "this" {
  for_each = var.attachments

  instance_id              = alicloud_cen_instance.this.id
  child_instance_id        = each.value.child_instance_id
  child_instance_type      = each.value.child_instance_type
  child_instance_region_id = each.value.child_instance_region_id
  child_instance_owner_id  = each.value.child_instance_owner_id
}

resource "alicloud_cen_bandwidth_package" "this" {
  count = var.create_bandwidth_package ? 1 : 0

  bandwidth                  = var.bandwidth
  cen_bandwidth_package_name = var.bandwidth_package_name
  geographic_region_a_id     = var.geographic_region_a_id
  geographic_region_b_id     = var.geographic_region_b_id
  payment_type               = var.bandwidth_payment_type
  period                     = var.bandwidth_payment_type == "PrePaid" ? var.bandwidth_period : null
}

resource "alicloud_cen_bandwidth_package_attachment" "this" {
  count = var.create_bandwidth_package ? 1 : 0

  instance_id          = alicloud_cen_instance.this.id
  bandwidth_package_id = alicloud_cen_bandwidth_package.this[0].id
}

resource "alicloud_cen_bandwidth_limit" "this" {
  for_each = var.create_bandwidth_package ? var.bandwidth_limits : {}

  instance_id     = alicloud_cen_instance.this.id
  region_ids      = each.value.region_ids
  bandwidth_limit = each.value.bandwidth_limit

  depends_on = [
    alicloud_cen_bandwidth_package_attachment.this,
    alicloud_cen_instance_attachment.this
  ]
}

resource "alicloud_cen_transit_router" "this" {
  count = var.create_transit_router ? 1 : 0

  cen_id                       = alicloud_cen_instance.this.id
  transit_router_name          = var.transit_router_name
  transit_router_description   = var.transit_router_description
  tags                         = local.common_tags

  lifecycle {
    precondition {
      condition     = var.transit_router_region_id != null && var.transit_router_region_id != ""
      error_message = "create_transit_router requires transit_router_region_id (set provider region accordingly)."
    }
  }
}

resource "alicloud_cen_transit_router_vpc_attachment" "this" {
  for_each = var.create_transit_router ? var.transit_router_vpc_attachments : {}

  cen_id                         = alicloud_cen_instance.this.id
  transit_router_id              = try(alicloud_cen_transit_router.this[0].transit_router_id, alicloud_cen_transit_router.this[0].id)
  vpc_id                         = each.value.vpc_id
  transit_router_attachment_name = coalesce(each.value.transit_router_attachment_name, each.key)
  auto_publish_route_enabled     = each.value.auto_publish_route_enabled
  tags                           = local.common_tags

  dynamic "zone_mappings" {
    for_each = each.value.zone_mappings
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.vswitch_id
    }
  }
}
