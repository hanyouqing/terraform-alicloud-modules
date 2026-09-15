locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/alb"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name     = var.load_balancer_name
  load_balancer_edition  = var.load_balancer_edition
  vpc_id                 = var.vpc_id
  address_type           = var.address_type
  address_allocated_mode = var.address_allocated_mode
  resource_group_id      = var.resource_group_id

  load_balancer_billing_config {
    pay_type = var.pay_type
  }

  dynamic "zone_mappings" {
    for_each = var.zone_mappings
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.vswitch_id
    }
  }

  tags = local.common_tags
}

resource "alicloud_alb_server_group" "this" {
  for_each = var.server_groups

  server_group_name = coalesce(each.value.server_group_name, each.key)
  server_group_type = each.value.server_group_type
  protocol          = each.value.protocol
  vpc_id            = var.vpc_id
  scheduler         = each.value.scheduler
  resource_group_id = var.resource_group_id

  sticky_session_config {
    sticky_session_enabled = try(each.value.sticky_session.sticky_session_enabled, false)
    sticky_session_type    = try(each.value.sticky_session.sticky_session_type, "Insert")
    cookie                 = try(each.value.sticky_session.cookie, null)
    cookie_timeout         = try(each.value.sticky_session.cookie_timeout, 1000)
  }

  health_check_config {
    health_check_enabled      = try(each.value.health_check.health_check_enabled, true)
    health_check_protocol     = try(each.value.health_check.health_check_protocol, "HTTP")
    health_check_path         = try(each.value.health_check.health_check_path, "/")
    health_check_method       = try(each.value.health_check.health_check_method, "HEAD")
    health_check_http_version = try(each.value.health_check.health_check_http_version, "HTTP1.1")
    health_check_codes        = try(each.value.health_check.health_check_codes, ["http_2xx", "http_3xx"])
    health_check_interval     = try(each.value.health_check.health_check_interval, 2)
    health_check_timeout      = try(each.value.health_check.health_check_timeout, 5)
    healthy_threshold         = try(each.value.health_check.healthy_threshold, 3)
    unhealthy_threshold       = try(each.value.health_check.unhealthy_threshold, 3)
    health_check_connect_port = try(each.value.health_check.health_check_connect_port, null)
    health_check_host         = try(each.value.health_check.health_check_host, null)
  }

  dynamic "servers" {
    for_each = each.value.servers
    content {
      server_id   = servers.value.server_id
      server_type = servers.value.server_type
      port        = servers.value.port
      weight      = servers.value.weight
      description = servers.value.description
      server_ip   = servers.value.server_ip
    }
  }

  tags = local.common_tags
}

resource "alicloud_alb_listener" "this" {
  for_each = var.listeners

  load_balancer_id     = alicloud_alb_load_balancer.this.id
  listener_protocol    = each.value.listener_protocol
  listener_port        = each.value.listener_port
  gzip_enabled         = each.value.gzip_enabled
  http2_enabled        = each.value.http2_enabled
  idle_timeout         = each.value.idle_timeout
  request_timeout      = each.value.request_timeout
  security_policy_id   = each.value.security_policy_id
  listener_description = each.value.description

  dynamic "certificates" {
    for_each = each.value.certificate_id != null ? [each.value.certificate_id] : []
    content {
      certificate_id = certificates.value
    }
  }

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this[each.value.server_group_key].id
      }
    }
  }
}
