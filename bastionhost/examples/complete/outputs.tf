output "instance_id" {
  description = "Bastionhost instance ID"
  value       = module.bastionhost.instance_id
}

output "user_ids" {
  description = "User IDs"
  value       = module.bastionhost.user_ids
}

output "host_ids" {
  description = "Host IDs"
  value       = module.bastionhost.host_ids
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.bastionhost.zzz_reminders
}
