output "instance_ids" {
  description = "SWAS instance IDs"
  value       = module.swas.instance_ids
}

output "public_ips" {
  description = "Public IPs"
  value       = module.swas.public_ips
}

output "private_ips" {
  description = "Private IPs when available"
  value       = module.swas.private_ips
}

output "firewall_rule_ids" {
  description = "Firewall rule IDs"
  value       = module.swas.firewall_rule_ids
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.swas.zzz_reminders
}
