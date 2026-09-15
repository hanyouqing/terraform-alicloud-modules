output "instance_ids" {
  description = "Hologres instance IDs"
  value       = module.hologram.instance_ids
}

output "endpoints" {
  description = "Endpoints"
  value       = module.hologram.endpoints
}

output "status" {
  description = "Status"
  value       = module.hologram.status
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.hologram.zzz_reminders
}
