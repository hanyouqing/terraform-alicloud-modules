locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/realtime-compute"
    Project     = var.project
    Environment = var.environment
  }

  vvp_resource_id = var.create_vvp_instance ? alicloud_realtime_compute_vvp_instance.this[0].resource_id : var.vvp_resource_id
}

resource "alicloud_realtime_compute_vvp_instance" "this" {
  count = var.create_vvp_instance ? 1 : 0

  payment_type      = var.payment_type
  vpc_id            = var.vpc_id
  vswitch_ids       = var.vswitch_ids
  vvp_instance_name = var.vvp_instance_name
  zone_id           = var.zone_id
  duration          = var.duration
  pricing_cycle     = var.pricing_cycle
  resource_group_id = var.resource_group_id
  tags              = merge(local.module_tags, var.tags)

  dynamic "resource_spec" {
    for_each = var.resource_spec != null ? [var.resource_spec] : []
    content {
      cpu       = resource_spec.value.cpu
      memory_gb = resource_spec.value.memory_gb
    }
  }

  dynamic "storage" {
    for_each = var.storage != null ? [var.storage] : []
    content {
      oss {
        bucket = storage.value.oss_bucket
      }
    }
  }

  lifecycle {
    precondition {
      condition     = !var.create_vvp_instance || (var.vpc_id != null && length(var.vswitch_ids) > 0 && var.zone_id != null && var.vvp_instance_name != null && var.storage != null)
      error_message = "Creating a VVP instance requires vvp_instance_name, payment_type, vpc_id, vswitch_ids, zone_id, and storage.oss_bucket."
    }
  }
}

resource "alicloud_realtime_compute_deployment" "this" {
  for_each = var.deployments

  deployment_name = coalesce(each.value.deployment_name, each.key)
  description     = each.value.description
  engine_version  = each.value.engine_version
  execution_mode  = each.value.execution_mode
  namespace       = each.value.namespace
  flink_conf      = length(each.value.flink_conf) > 0 ? each.value.flink_conf : null
  labels          = length(each.value.labels) > 0 ? each.value.labels : null
  resource_id     = try(coalesce(each.value.resource_id, local.vvp_resource_id), null)

  deployment_target {
    mode = each.value.deployment_target.mode
    name = each.value.deployment_target.name
  }

  artifact {
    kind = each.value.artifact.kind

    dynamic "jar_artifact" {
      for_each = each.value.artifact.jar_artifact != null ? [each.value.artifact.jar_artifact] : []
      content {
        additional_dependencies = jar_artifact.value.additional_dependencies
        entry_class             = jar_artifact.value.entry_class
        jar_uri                 = jar_artifact.value.jar_uri
        main_args               = jar_artifact.value.main_args
      }
    }

    dynamic "python_artifact" {
      for_each = each.value.artifact.python_artifact != null ? [each.value.artifact.python_artifact] : []
      content {
        additional_dependencies     = python_artifact.value.additional_dependencies
        additional_python_archives  = python_artifact.value.additional_python_archives
        additional_python_libraries = python_artifact.value.additional_python_libraries
        entry_module                = python_artifact.value.entry_module
        main_args                   = python_artifact.value.main_args
        python_artifact_uri         = python_artifact.value.python_artifact_uri
      }
    }

    dynamic "sql_artifact" {
      for_each = each.value.artifact.sql_artifact != null ? [each.value.artifact.sql_artifact] : []
      content {
        additional_dependencies = sql_artifact.value.additional_dependencies
        sql_script              = sql_artifact.value.sql_script
      }
    }
  }

  lifecycle {
    precondition {
      condition     = try(coalesce(each.value.resource_id, local.vvp_resource_id), null) != null
      error_message = "Each deployment requires resource_id, or create_vvp_instance=true / vvp_resource_id set."
    }
  }
}
