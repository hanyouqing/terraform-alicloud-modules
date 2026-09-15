locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/vpc"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  nat_vswitch_key_effective = var.create_nat_gateway ? (
    var.nat_vswitch_key != null ? var.nat_vswitch_key : (
      length(var.public_vswitches) > 0 ? keys(var.public_vswitches)[0] : null
    )
  ) : null
}

resource "alicloud_vpc" "this" {
  vpc_name              = var.vpc_name
  cidr_block            = var.cidr_block
  secondary_cidr_blocks = length(var.secondary_cidr_blocks) > 0 ? var.secondary_cidr_blocks : null
  description           = var.description
  resource_group_id     = var.resource_group_id
  tags                  = local.common_tags
}

resource "alicloud_vswitch" "public" {
  for_each = var.public_vswitches

  vpc_id       = alicloud_vpc.this.id
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id
  vswitch_name = coalesce(each.value.vswitch_name, each.key)
  description  = each.value.description
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/vswitch/public"
      Type   = "public"
    }
  )
}

resource "alicloud_vswitch" "private" {
  for_each = var.private_vswitches

  vpc_id       = alicloud_vpc.this.id
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id
  vswitch_name = coalesce(each.value.vswitch_name, each.key)
  description  = each.value.description
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/vswitch/private"
      Type   = "private"
    }
  )
}

resource "alicloud_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  vpc_id           = alicloud_vpc.this.id
  nat_gateway_name = var.nat_gateway_name
  nat_type         = "Enhanced"
  vswitch_id       = alicloud_vswitch.public[local.nat_vswitch_key_effective].id
  payment_type     = "PayAsYouGo"
  specification    = var.nat_gateway_specification
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/nat-gateway"
    }
  )

  lifecycle {
    precondition {
      condition     = local.nat_vswitch_key_effective != null
      error_message = "create_nat_gateway requires at least one public_vswitches entry (or an explicit nat_vswitch_key)."
    }
  }
}

resource "alicloud_eip_address" "nat" {
  count = var.create_nat_gateway ? 1 : 0

  address_name         = "${var.nat_gateway_name}-eip"
  bandwidth            = var.eip_bandwidth
  internet_charge_type = var.eip_internet_charge_type
  payment_type         = "PayAsYouGo"
  resource_group_id    = var.resource_group_id
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/eip"
    }
  )
}

resource "alicloud_eip_association" "nat" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = alicloud_eip_address.nat[0].id
  instance_id   = alicloud_nat_gateway.this[0].id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "private" {
  for_each = var.create_nat_gateway ? var.private_vswitches : {}

  snat_table_id     = alicloud_nat_gateway.this[0].snat_table_ids
  source_vswitch_id = alicloud_vswitch.private[each.key].id
  snat_ip           = alicloud_eip_address.nat[0].ip_address

  depends_on = [alicloud_eip_association.nat]
}

resource "alicloud_route_table" "public" {
  for_each = var.create_public_route_tables ? var.public_vswitches : {}

  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${coalesce(each.value.vswitch_name, each.key)}-rt"
  description      = "Custom public route table for ${coalesce(each.value.vswitch_name, each.key)}"
  associate_type   = "VSwitch"
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/route-table/public"
      Type   = "public"
    }
  )
}

resource "alicloud_route_table_attachment" "public" {
  for_each = var.create_public_route_tables ? var.public_vswitches : {}

  vswitch_id     = alicloud_vswitch.public[each.key].id
  route_table_id = alicloud_route_table.public[each.key].id
}

resource "alicloud_route_table" "private" {
  for_each = var.create_private_route_tables ? var.private_vswitches : {}

  vpc_id           = alicloud_vpc.this.id
  route_table_name = "${coalesce(each.value.vswitch_name, each.key)}-rt"
  description      = "Custom private route table for ${coalesce(each.value.vswitch_name, each.key)}"
  associate_type   = "VSwitch"
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/vpc/route-table/private"
      Type   = "private"
    }
  )
}

resource "alicloud_route_entry" "private_default" {
  for_each = var.create_private_route_tables && var.create_nat_gateway ? var.private_vswitches : {}

  route_table_id        = alicloud_route_table.private[each.key].id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.this[0].id
}

resource "alicloud_route_table_attachment" "private" {
  for_each = var.create_private_route_tables ? var.private_vswitches : {}

  vswitch_id     = alicloud_vswitch.private[each.key].id
  route_table_id = alicloud_route_table.private[each.key].id
}

resource "alicloud_vpc_flow_log" "this" {
  count = var.enable_flow_log ? 1 : 0

  flow_log_name  = var.flow_log_name
  resource_type  = "VPC"
  resource_id    = alicloud_vpc.this.id
  traffic_type   = var.flow_log_traffic_type
  project_name   = var.flow_log_project
  log_store_name = var.flow_log_logstore
  status         = "Active"

  lifecycle {
    precondition {
      condition     = var.flow_log_project != null && var.flow_log_project != "" && var.flow_log_logstore != null && var.flow_log_logstore != ""
      error_message = "enable_flow_log requires flow_log_project and flow_log_logstore (existing SLS project and logstore)."
    }
  }
}
