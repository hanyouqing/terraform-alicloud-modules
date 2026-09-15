output "contact_ids" {
  description = "Contact IDs"
  value       = module.cms.contact_ids
}

output "contact_group_ids" {
  description = "Contact group IDs"
  value       = module.cms.contact_group_ids
}

output "alarm_ids" {
  description = "Alarm IDs"
  value       = module.cms.alarm_ids
}

output "site_monitor_ids" {
  description = "Site monitor IDs"
  value       = module.cms.site_monitor_ids
}

output "monitor_group_id" {
  description = "Monitor group ID"
  value       = module.cms.monitor_group_id
}
