locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/express-connect"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  physical_connection_id_effective = var.create_physical_connection ? (
    alicloud_express_connect_physical_connection.this[0].id
  ) : var.physical_connection_id
}

resource "alicloud_express_connect_physical_connection" "this" {
  count = var.create_physical_connection ? 1 : 0

  access_point_id                  = var.access_point_id
  line_operator                    = var.line_operator
  physical_connection_name         = var.physical_connection_name
  peer_location                    = var.peer_location
  type                             = "VPC"
  description                      = var.physical_connection_description
  port_type                        = var.port_type
  bandwidth                        = var.bandwidth
  circuit_code                     = var.circuit_code
  redundant_physical_connection_id = var.redundant_physical_connection_id
  status                           = var.physical_connection_status
  period                           = var.physical_connection_status == "Enabled" ? var.period : null
  pricing_cycle                    = var.physical_connection_status == "Enabled" ? var.pricing_cycle : null

  lifecycle {
    precondition {
      condition     = var.access_point_id != null && var.access_point_id != "" && var.line_operator != null && var.line_operator != ""
      error_message = "create_physical_connection requires access_point_id and line_operator."
    }
  }
}

resource "alicloud_express_connect_virtual_border_router" "this" {
  for_each = var.virtual_border_routers

  physical_connection_id     = coalesce(each.value.physical_connection_id, local.physical_connection_id_effective)
  vlan_id                    = each.value.vlan_id
  local_gateway_ip           = each.value.local_gateway_ip
  peer_gateway_ip            = each.value.peer_gateway_ip
  peering_subnet_mask        = each.value.peering_subnet_mask
  virtual_border_router_name = coalesce(each.value.virtual_border_router_name, each.key)
  description                = each.value.description
  bandwidth                  = each.value.bandwidth
  circuit_code               = each.value.circuit_code
  detect_multiplier          = each.value.detect_multiplier
  min_rx_interval            = each.value.min_rx_interval
  min_tx_interval            = each.value.min_tx_interval
  enable_ipv6                = each.value.enable_ipv6
  local_ipv6_gateway_ip      = each.value.local_ipv6_gateway_ip
  peer_ipv6_gateway_ip       = each.value.peer_ipv6_gateway_ip
  peering_ipv6_subnet_mask   = each.value.peering_ipv6_subnet_mask
  mtu                        = each.value.mtu
  sitelink_enable            = each.value.sitelink_enable
  resource_group_id          = each.value.resource_group_id
  vbr_owner_id               = each.value.vbr_owner_id
  status                     = each.value.status
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/express-connect/vbr"
    },
    each.value.tags
  )

  lifecycle {
    precondition {
      condition     = coalesce(each.value.physical_connection_id, local.physical_connection_id_effective) != null
      error_message = "Each VBR requires a physical_connection_id (module default or per-entry override). Set create_physical_connection=true or pass physical_connection_id."
    }
  }
}

resource "alicloud_express_connect_router_interface" "this" {
  for_each = var.router_interfaces

  router_id                   = alicloud_express_connect_virtual_border_router.this[each.value.vbr_key].id
  router_type                 = each.value.router_type
  role                        = each.value.role
  spec                        = each.value.spec
  opposite_region_id          = each.value.opposite_region_id
  opposite_router_type        = each.value.opposite_router_type
  opposite_router_id          = each.value.opposite_router_id
  opposite_interface_owner_id = each.value.opposite_interface_owner_id
  access_point_id             = each.value.access_point_id
  opposite_access_point_id    = each.value.opposite_access_point_id
  router_interface_name       = coalesce(each.value.router_interface_name, each.key)
  description                 = each.value.description
  payment_type                = each.value.payment_type
  period                      = each.value.period
  pricing_cycle               = each.value.pricing_cycle
  auto_renew                  = each.value.auto_renew
  fast_link_mode              = each.value.fast_link_mode
  hc_rate                     = each.value.hc_rate
  hc_threshold                = each.value.hc_threshold
  health_check_source_ip      = each.value.health_check_source_ip
  health_check_target_ip      = each.value.health_check_target_ip
  resource_group_id           = each.value.resource_group_id
  status                      = each.value.status
  tags = merge(
    local.common_tags,
    {
      Module = "github.com/hanyouqing/terraform-alicloud-modules/express-connect/router-interface"
    },
    each.value.tags
  )
}
