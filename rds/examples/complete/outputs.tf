output "instance_ids" {
  description = "RDS instance IDs"
  value       = module.rds.instance_ids
}

output "connection_strings" {
  description = "Connection strings"
  value       = module.rds.connection_strings
}

output "ports" {
  description = "Ports"
  value       = module.rds.ports
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.rds.zzz_reminders
}
