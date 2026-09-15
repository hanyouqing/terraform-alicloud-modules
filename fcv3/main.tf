locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/fcv3"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_fcv3_function" "this" {
  for_each = var.functions

  function_name         = coalesce(each.value.function_name, each.key)
  handler               = each.value.handler
  runtime               = each.value.runtime
  description           = each.value.description
  timeout               = each.value.timeout
  memory_size           = each.value.memory_size
  cpu                   = each.value.cpu
  disk_size             = each.value.disk_size
  instance_concurrency  = each.value.instance_concurrency
  internet_access       = each.value.internet_access
  role                  = each.value.role
  layers                = length(each.value.layers) > 0 ? each.value.layers : null
  environment_variables = length(each.value.environment_variables) > 0 ? each.value.environment_variables : null
  resource_group_id     = each.value.resource_group_id

  tags = merge(local.module_tags, var.tags, each.value.tags)

  dynamic "code" {
    for_each = each.value.code != null ? [each.value.code] : []
    content {
      oss_bucket_name = code.value.oss_bucket_name
      oss_object_name = code.value.oss_object_name
      zip_file        = code.value.zip_file
      checksum        = code.value.checksum
    }
  }

  dynamic "vpc_config" {
    for_each = each.value.vpc_config != null ? [each.value.vpc_config] : []
    content {
      vpc_id            = vpc_config.value.vpc_id
      vswitch_ids       = vpc_config.value.vswitch_ids
      security_group_id = vpc_config.value.security_group_id
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_config != null ? [each.value.log_config] : []
    content {
      project                 = log_config.value.project
      logstore                = log_config.value.logstore
      enable_instance_metrics = log_config.value.enable_instance_metrics
      enable_request_metrics  = log_config.value.enable_request_metrics
      log_begin_rule          = log_config.value.log_begin_rule
    }
  }

  dynamic "gpu_config" {
    for_each = each.value.gpu_config != null ? [each.value.gpu_config] : []
    content {
      gpu_memory_size = gpu_config.value.gpu_memory_size
      gpu_type        = gpu_config.value.gpu_type
    }
  }
}

resource "alicloud_fcv3_trigger" "this" {
  for_each = var.triggers

  function_name   = alicloud_fcv3_function.this[each.value.function_key].function_name
  trigger_type    = each.value.trigger_type
  qualifier       = each.value.qualifier
  trigger_name    = coalesce(each.value.trigger_name, each.key)
  description     = each.value.description
  source_arn      = each.value.source_arn
  invocation_role = each.value.invocation_role
  trigger_config  = each.value.trigger_config
}

resource "alicloud_fcv3_custom_domain" "this" {
  for_each = var.custom_domains

  custom_domain_name = coalesce(each.value.custom_domain_name, each.key)
  protocol           = each.value.protocol
  certificate_id     = each.value.certificate_id

  dynamic "auth_config" {
    for_each = each.value.auth_config != null ? [each.value.auth_config] : []
    content {
      auth_type = auth_config.value.auth_type
      auth_info = auth_config.value.auth_info
    }
  }

  dynamic "cert_config" {
    for_each = each.value.cert_config != null ? [each.value.cert_config] : []
    content {
      cert_name   = cert_config.value.cert_name
      certificate = cert_config.value.certificate
      private_key = cert_config.value.private_key
    }
  }

  dynamic "route_config" {
    for_each = each.value.route_config != null ? [each.value.route_config] : []
    content {
      dynamic "routes" {
        for_each = route_config.value.routes
        content {
          function_name = coalesce(
            routes.value.function_name,
            try(alicloud_fcv3_function.this[routes.value.function_key].function_name, null)
          )
          path      = routes.value.path
          methods   = routes.value.methods
          qualifier = routes.value.qualifier
        }
      }
    }
  }

  dynamic "tls_config" {
    for_each = each.value.tls_config != null ? [each.value.tls_config] : []
    content {
      min_version   = tls_config.value.min_version
      max_version   = tls_config.value.max_version
      cipher_suites = tls_config.value.cipher_suites
    }
  }

  dynamic "waf_config" {
    for_each = each.value.waf_config != null ? [each.value.waf_config] : []
    content {
      enable_waf = waf_config.value.enable_waf
    }
  }

  dynamic "cors_config" {
    for_each = each.value.cors_config != null ? [each.value.cors_config] : []
    content {
      allow_credentials = cors_config.value.allow_credentials
      allow_headers     = cors_config.value.allow_headers
      allow_methods     = cors_config.value.allow_methods
      allow_origins     = cors_config.value.allow_origins
      expose_headers    = cors_config.value.expose_headers
      max_age           = cors_config.value.max_age
    }
  }
}
