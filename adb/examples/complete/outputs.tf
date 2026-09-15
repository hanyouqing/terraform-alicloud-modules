output "cluster_ids" {
  description = "Cluster IDs"
  value       = module.adb.cluster_ids
}

output "connection_strings" {
  description = "Connection strings"
  value       = module.adb.connection_strings
}

output "ports" {
  description = "Ports"
  value       = module.adb.ports
}

output "account_names" {
  description = "Account names"
  value       = module.adb.account_names
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.adb.zzz_reminders
}
