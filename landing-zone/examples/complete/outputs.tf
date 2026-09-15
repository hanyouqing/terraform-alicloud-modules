output "directory_id" {
  description = "Resource Directory ID when created"
  value       = module.landing_zone.directory_id
}

output "folder_ids" {
  description = "Folder IDs"
  value       = module.landing_zone.folder_ids
}

output "account_ids" {
  description = "Member account IDs"
  value       = module.landing_zone.account_ids
}

output "policy_ids" {
  description = "Baseline control policy IDs"
  value       = module.landing_zone.policy_ids
}

output "zzz_reminders" {
  description = "Landing Zone next steps"
  value       = module.landing_zone.zzz_reminders
}
