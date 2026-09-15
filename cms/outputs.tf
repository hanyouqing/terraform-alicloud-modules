output "contact_ids" {
  description = "Map of CMS alarm contact IDs (same as contact names)"
  value       = { for k, v in alicloud_cms_alarm_contact.this : k => v.id }
}

output "contact_group_ids" {
  description = "Map of CMS alarm contact group IDs"
  value       = { for k, v in alicloud_cms_alarm_contact_group.this : k => v.id }
}

output "contact_group_names" {
  description = "Map of CMS alarm contact group names"
  value       = { for k, v in alicloud_cms_alarm_contact_group.this : k => v.alarm_contact_group_name }
}

output "alarm_ids" {
  description = "Map of CMS alarm rule IDs"
  value       = { for k, v in alicloud_cms_alarm.this : k => v.id }
}

output "site_monitor_ids" {
  description = "Map of CMS site monitor IDs"
  value       = { for k, v in alicloud_cms_site_monitor.this : k => v.id }
}

output "monitor_group_id" {
  description = "ID of the optional CMS monitor group"
  value       = var.monitor_group != null ? alicloud_cms_monitor_group.this[0].id : null
}

output "zzz_reminders" {
  description = "Operational reminders for CMS alerting"
  value = {
    next_steps = [
      "Activate email/SMS verification links for new contacts before alerts deliver",
      "Route production alerts through contact groups (DingTalk/webhook), not individual SMS",
      "Tune silence_time and escalations thresholds before go-live"
    ]
    security_notes = [
      "Prefer DingTalk webhooks or secure email over SMS spam for on-call",
      "Restrict webhook endpoints and rotate secrets outside Terraform state when possible"
    ]
    cost_optimization = [
      "Site monitors and high-frequency alarms increase CMS evaluation cost",
      "Use contact groups to avoid duplicate SMS charges per individual contact"
    ]
    important_resources = {
      contact_count       = length(alicloud_cms_alarm_contact.this)
      contact_group_count = length(alicloud_cms_alarm_contact_group.this)
      alarm_count         = length(alicloud_cms_alarm.this)
      site_monitor_count  = length(alicloud_cms_site_monitor.this)
      monitor_group_id    = var.monitor_group != null ? alicloud_cms_monitor_group.this[0].id : null
    }
  }
}
