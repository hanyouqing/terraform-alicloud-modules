output "disk_ids" {
  description = "Disk IDs"
  value       = module.disk.disk_ids
}

output "attachments" {
  description = "Attachment IDs"
  value       = module.disk.attachments
}

output "snapshot_policy_ids" {
  description = "Snapshot policy IDs"
  value       = module.disk.snapshot_policy_ids
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.disk.zzz_reminders
}
