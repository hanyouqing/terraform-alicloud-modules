locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/vpn"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_vpn_gateway" "this" {
  vpn_gateway_name  = var.vpn_gateway_name
  vpc_id            = var.vpc_id
  vswitch_id        = var.vswitch_id
  bandwidth         = var.bandwidth
  enable_ipsec      = var.enable_ipsec
  enable_ssl        = var.enable_ssl
  ssl_connections   = var.enable_ssl ? var.ssl_connections : null
  network_type      = var.network_type
  payment_type      = var.payment_type
  auto_propagate    = var.auto_propagate
  description       = var.description
  resource_group_id = var.resource_group_id
  tags              = local.common_tags
}

resource "alicloud_vpn_customer_gateway" "this" {
  for_each = var.customer_gateways

  customer_gateway_name = coalesce(each.value.name, each.key)
  ip_address            = each.value.ip_address
  asn                   = each.value.asn
  description           = each.value.description
  tags                  = local.common_tags
}

resource "alicloud_vpn_connection" "this" {
  for_each = var.connections

  vpn_gateway_id       = alicloud_vpn_gateway.this.id
  vpn_connection_name  = coalesce(each.value.name, each.key)
  customer_gateway_id  = alicloud_vpn_customer_gateway.this[each.value.customer_gateway_key].id
  local_subnet         = each.value.local_subnet
  remote_subnet        = each.value.remote_subnet
  effect_immediately   = each.value.effect_immediately
  enable_dpd           = each.value.enable_dpd
  enable_nat_traversal = each.value.enable_nat_traversal

  dynamic "ike_config" {
    for_each = each.value.ike_config != null ? [each.value.ike_config] : []
    content {
      psk           = ike_config.value.psk
      ike_version   = ike_config.value.ike_version
      ike_mode      = ike_config.value.ike_mode
      ike_enc_alg   = ike_config.value.ike_enc_alg
      ike_auth_alg  = ike_config.value.ike_auth_alg
      ike_pfs       = ike_config.value.ike_pfs
      ike_lifetime  = ike_config.value.ike_lifetime
      ike_local_id  = ike_config.value.local_id
      ike_remote_id = ike_config.value.remote_id
    }
  }

  dynamic "ipsec_config" {
    for_each = each.value.ipsec_config != null ? [each.value.ipsec_config] : []
    content {
      ipsec_enc_alg  = ipsec_config.value.ipsec_enc_alg
      ipsec_auth_alg = ipsec_config.value.ipsec_auth_alg
      ipsec_pfs      = ipsec_config.value.ipsec_pfs
      ipsec_lifetime = ipsec_config.value.ipsec_lifetime
    }
  }

  tags = local.common_tags
}
