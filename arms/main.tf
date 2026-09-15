locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/arms"
    Project     = var.project
    Environment = var.environment
  }

  grafana_instance_id_effective = var.create_grafana_workspace ? alicloud_arms_grafana_workspace.this[0].id : var.grafana_instance_id
}

resource "alicloud_arms_grafana_workspace" "this" {
  count = var.create_grafana_workspace ? 1 : 0

  grafana_workspace_name    = var.grafana_workspace_name
  grafana_workspace_edition = var.grafana_workspace_edition
  grafana_version           = var.grafana_version
  description               = var.grafana_description
  password                  = var.grafana_password
  resource_group_id         = var.grafana_resource_group_id
  tags                      = merge(local.module_tags, var.tags)

  lifecycle {
    precondition {
      condition     = var.grafana_workspace_name != null && var.grafana_workspace_name != ""
      error_message = "create_grafana_workspace requires grafana_workspace_name."
    }
  }
}

resource "alicloud_arms_prometheus" "this" {
  for_each = var.prometheus

  cluster_type        = each.value.cluster_type
  cluster_name        = coalesce(each.value.cluster_name, each.key)
  cluster_id          = each.value.cluster_id
  vpc_id              = each.value.vpc_id
  vswitch_id          = each.value.vswitch_id
  security_group_id   = each.value.security_group_id
  grafana_instance_id = each.value.grafana_instance_id != null ? each.value.grafana_instance_id : local.grafana_instance_id_effective
  resource_group_id   = each.value.resource_group_id
  payment_type        = each.value.payment_type
  duration            = each.value.duration
  archive_duration    = each.value.archive_duration
  sub_clusters_json   = each.value.sub_clusters_json
  tags                = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    precondition {
      condition = (
        each.value.grafana_instance_id != null || local.grafana_instance_id_effective != null
      )
      error_message = "Each Prometheus requires grafana_instance_id (per-entry, created workspace, or var.grafana_instance_id)."
    }
  }
}

resource "alicloud_arms_environment" "this" {
  for_each = var.environments

  environment_type     = each.value.environment_type
  environment_sub_type = each.value.environment_sub_type
  environment_name     = coalesce(each.value.environment_name, each.key)
  bind_resource_id     = each.value.bind_resource_id
  managed_type         = each.value.managed_type
  drop_metrics         = each.value.drop_metrics
  resource_group_id    = each.value.resource_group_id
  aliyun_lang          = each.value.aliyun_lang
  tags                 = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_arms_alert_contact" "this" {
  for_each = var.alert_contacts

  alert_contact_name     = coalesce(each.value.alert_contact_name, each.key)
  email                  = each.value.email
  phone_num              = each.value.phone_num
  ding_robot_webhook_url = each.value.ding_robot_webhook_url
  system_noc             = each.value.system_noc
}

resource "alicloud_arms_alert_contact_group" "this" {
  for_each = var.alert_contact_groups

  alert_contact_group_name = coalesce(each.value.alert_contact_group_name, each.key)
  contact_ids = distinct(concat(
    each.value.contact_ids,
    [
      for k in each.value.contact_keys :
      alicloud_arms_alert_contact.this[k].id
    ]
  ))
}
