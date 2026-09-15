locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/nlb"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  server_attachments = {
    for pair in flatten([
      for sg_key, sg in var.server_groups : [
        for idx, server in sg.servers : {
          key   = "${sg_key}:${idx}"
          value = merge(server, { server_group_key = sg_key })
        }
      ]
    ]) : pair.key => pair.value
  }
}

resource "alicloud_nlb_load_balancer" "this" {
  load_balancer_name = var.load_balancer_name
  load_balancer_type = "Network"
  vpc_id             = var.vpc_id
  address_type       = var.address_type
  address_ip_version = var.address_ip_version
  cross_zone_enabled = var.cross_zone_enabled
  resource_group_id  = var.resource_group_id
  security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : null

  dynamic "zone_mappings" {
    for_each = var.zone_mappings
    content {
      zone_id              = zone_mappings.value.zone_id
      vswitch_id           = zone_mappings.value.vswitch_id
      private_ipv4_address = zone_mappings.value.private_ipv4_address
      allocation_id        = zone_mappings.value.allocation_id
    }
  }

  tags = local.common_tags
}

resource "alicloud_nlb_server_group" "this" {
  for_each = var.server_groups

  server_group_name        = coalesce(each.value.server_group_name, each.key)
  server_group_type        = each.value.server_group_type
  vpc_id                   = var.vpc_id
  protocol                 = each.value.protocol
  scheduler                = each.value.scheduler
  address_ip_version       = each.value.address_ip_version
  connection_drain_enabled = each.value.connection_drain_enabled
  connection_drain_timeout = each.value.connection_drain_enabled ? each.value.connection_drain_timeout : null
  resource_group_id        = var.resource_group_id
  tags                     = local.common_tags

  health_check {
    health_check_enabled         = try(each.value.health_check.health_check_enabled, true)
    health_check_type            = try(each.value.health_check.health_check_type, "TCP")
    health_check_connect_port    = try(each.value.health_check.health_check_connect_port, 0)
    healthy_threshold            = try(each.value.health_check.healthy_threshold, 2)
    unhealthy_threshold          = try(each.value.health_check.unhealthy_threshold, 2)
    health_check_connect_timeout = try(each.value.health_check.health_check_connect_timeout, 5)
    health_check_interval        = try(each.value.health_check.health_check_interval, 10)
    health_check_domain          = try(each.value.health_check.health_check_domain, null)
    health_check_url             = try(each.value.health_check.health_check_url, null)
    http_check_method            = try(each.value.health_check.http_check_method, null)
    health_check_http_code       = try(each.value.health_check.health_check_http_code, null)
  }
}

resource "alicloud_nlb_server_group_server_attachment" "this" {
  for_each = local.server_attachments

  server_group_id = alicloud_nlb_server_group.this[each.value.server_group_key].id
  server_id       = each.value.server_id
  server_type     = each.value.server_type
  server_ip       = each.value.server_ip
  port            = each.value.port
  weight          = each.value.weight
  description     = each.value.description
}

resource "alicloud_nlb_listener" "this" {
  for_each = var.listeners

  load_balancer_id       = alicloud_nlb_load_balancer.this.id
  server_group_id        = alicloud_nlb_server_group.this[each.value.server_group_key].id
  listener_protocol      = each.value.listener_protocol
  listener_port          = each.value.listener_port
  listener_description   = coalesce(each.value.description, each.key)
  idle_timeout           = each.value.idle_timeout
  proxy_protocol_enabled = each.value.proxy_protocol_enabled
  cps                    = each.value.cps
  mss                    = each.value.mss
  certificate_ids        = each.value.listener_protocol == "TCPSSL" ? each.value.certificate_ids : null
  ca_enabled             = each.value.listener_protocol == "TCPSSL" ? each.value.ca_enabled : null
  ca_certificate_ids     = each.value.listener_protocol == "TCPSSL" ? each.value.ca_certificate_ids : null
  security_policy_id     = each.value.listener_protocol == "TCPSSL" ? each.value.security_policy_id : null
  alpn_enabled           = each.value.listener_protocol == "TCPSSL" ? each.value.alpn_enabled : null
  alpn_policy            = each.value.listener_protocol == "TCPSSL" ? each.value.alpn_policy : null
}
