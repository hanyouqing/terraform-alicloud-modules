output "trail_ids" {
  description = "Map of trail keys to trail IDs"
  value       = { for k, v in alicloud_actiontrail_trail.this : k => v.id }
}

output "trail_names" {
  description = "Map of trail keys to trail names"
  value       = { for k, v in alicloud_actiontrail_trail.this : k => v.trail_name }
}

output "common_tags" {
  description = "Merged tagging convention for this module"
  value       = local.common_tags
}
