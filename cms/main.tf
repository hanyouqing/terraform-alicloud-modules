locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/cms"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  alarm_metric_dimensions = {
    for k, v in var.alarms : k => (
      v.metric_dimensions != null ? v.metric_dimensions : (
        v.dimensions != null ? jsonencode(v.dimensions) : null
      )
    )
  }
}

resource "alicloud_cms_alarm_contact" "this" {
  for_each = var.contacts

  alarm_contact_name     = coalesce(each.value.alarm_contact_name, each.key)
  describe               = each.value.describe
  channels_mail          = each.value.channels_mail
  channels_sms           = each.value.channels_sms
  channels_ding_web_hook = each.value.channels_ding_web_hook
  channels_aliim         = each.value.channels_aliim
  lang                   = each.value.lang

  lifecycle {
    ignore_changes = [channels_mail, channels_sms]
  }
}

resource "alicloud_cms_alarm_contact_group" "this" {
  for_each = var.contact_groups

  alarm_contact_group_name = coalesce(each.value.alarm_contact_group_name, each.key)
  describe                 = each.value.describe
  enable_subscribed        = each.value.enable_subscribed
  contacts = [
    for c in each.value.contacts :
    contains(keys(alicloud_cms_alarm_contact.this), c) ? alicloud_cms_alarm_contact.this[c].id : c
  ]
}

resource "alicloud_cms_alarm" "this" {
  for_each = var.alarms

  name               = coalesce(each.value.name, each.key)
  project            = each.value.project
  metric             = each.value.metric
  period             = each.value.period
  silence_time       = each.value.silence_time
  webhook            = each.value.webhook
  enabled            = each.value.enabled
  effective_interval = each.value.effective_interval
  metric_dimensions  = local.alarm_metric_dimensions[each.key]
  contact_groups = [
    for g in each.value.contact_groups :
    contains(keys(alicloud_cms_alarm_contact_group.this), g) ? alicloud_cms_alarm_contact_group.this[g].alarm_contact_group_name : g
  ]
  tags = local.common_tags

  escalations_critical {
    statistics          = each.value.statistics
    comparison_operator = each.value.comparison_operator
    threshold           = each.value.threshold
    times               = each.value.times
  }

  dynamic "escalations_warn" {
    for_each = each.value.warn != null ? [each.value.warn] : []
    content {
      statistics          = escalations_warn.value.statistics
      comparison_operator = escalations_warn.value.comparison_operator
      threshold           = escalations_warn.value.threshold
      times               = escalations_warn.value.times
    }
  }

  dynamic "escalations_info" {
    for_each = each.value.info != null ? [each.value.info] : []
    content {
      statistics          = escalations_info.value.statistics
      comparison_operator = escalations_info.value.comparison_operator
      threshold           = escalations_info.value.threshold
      times               = escalations_info.value.times
    }
  }
}

resource "alicloud_cms_site_monitor" "this" {
  for_each = var.site_monitors

  address   = each.value.address
  task_name = coalesce(each.value.task_name, each.key)
  task_type = each.value.task_type
  interval  = each.value.interval
  status    = each.value.status

  dynamic "isp_cities" {
    for_each = each.value.isp_cities
    content {
      city = isp_cities.value.city
      isp  = isp_cities.value.isp
      type = isp_cities.value.type
    }
  }
}

resource "alicloud_cms_monitor_group" "this" {
  count = var.monitor_group != null ? 1 : 0

  monitor_group_name = var.monitor_group.monitor_group_name
  contact_groups = [
    for g in var.monitor_group.contact_groups :
    contains(keys(alicloud_cms_alarm_contact_group.this), g) ? alicloud_cms_alarm_contact_group.this[g].alarm_contact_group_name : g
  ]
  resource_group_id   = var.monitor_group.resource_group_id
  resource_group_name = var.monitor_group.resource_group_name
  tags                = local.common_tags
}
