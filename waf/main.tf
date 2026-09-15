locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/waf"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  instance_id = var.create_instance ? alicloud_wafv3_instance.this[0].id : var.instance_id
}

resource "alicloud_wafv3_instance" "this" {
  count = var.create_instance ? 1 : 0
}

resource "alicloud_wafv3_domain" "this" {
  for_each = var.domains

  instance_id                        = local.instance_id
  domain                             = coalesce(each.value.domain, each.key)
  access_type                        = each.value.access_type
  resource_manager_resource_group_id = each.value.resource_manager_resource_group_id
  tags                               = local.common_tags

  listen {
    http_ports          = each.value.listen.http_ports
    https_ports         = each.value.listen.https_ports
    cert_id             = each.value.listen.cert_id
    tls_version         = each.value.listen.tls_version
    enable_tlsv3        = each.value.listen.enable_tlsv3
    http2_enabled       = each.value.listen.http2_enabled
    ipv6_enabled        = each.value.listen.ipv6_enabled
    exclusive_ip        = each.value.listen.exclusive_ip
    focus_https         = each.value.listen.focus_https
    protection_resource = each.value.listen.protection_resource
    cipher_suite        = each.value.listen.cipher_suite
    custom_ciphers      = each.value.listen.custom_ciphers
    xff_header_mode     = each.value.listen.xff_header_mode
    xff_headers         = each.value.listen.xff_headers
  }

  redirect {
    backends           = each.value.redirect.backends
    loadbalance        = each.value.redirect.loadbalance
    connect_timeout    = each.value.redirect.connect_timeout
    read_timeout       = each.value.redirect.read_timeout
    write_timeout      = each.value.redirect.write_timeout
    keepalive          = each.value.redirect.keepalive
    retry              = each.value.redirect.retry
    sni_enabled        = each.value.redirect.sni_enabled
    sni_host           = each.value.redirect.sni_host
    focus_http_backend = each.value.redirect.focus_http_backend
    keepalive_requests = each.value.redirect.keepalive_requests
    keepalive_timeout  = each.value.redirect.keepalive_timeout

    dynamic "request_headers" {
      for_each = each.value.redirect.request_headers
      content {
        key   = request_headers.value.key
        value = request_headers.value.value
      }
    }
  }

  lifecycle {
    precondition {
      condition     = local.instance_id != null && local.instance_id != ""
      error_message = "Set create_instance=true or provide instance_id for WAFv3 domains."
    }
  }
}
