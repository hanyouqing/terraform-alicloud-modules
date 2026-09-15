output "cluster_id" {
  description = "Cluster ID"
  value       = module.emr.cluster_id
}

output "security_mode" {
  description = "Security mode"
  value       = module.emr.security_mode
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.emr.zzz_reminders
}
