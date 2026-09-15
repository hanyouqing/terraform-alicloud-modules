output "instance_ids" {
  description = "Instance IDs"
  value       = module.ecs.instance_ids
}

output "private_ips" {
  description = "Private IPs"
  value       = module.ecs.private_ips
}

output "public_ips" {
  description = "Public IPs"
  value       = module.ecs.public_ips
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.ecs.zzz_reminders
}
