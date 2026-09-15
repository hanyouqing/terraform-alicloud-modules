output "prometheus_ids" {
  description = "Prometheus IDs"
  value       = module.arms.prometheus_ids
}

output "grafana_workspace_id" {
  description = "Grafana workspace ID"
  value       = module.arms.grafana_workspace_id
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.arms.zzz_reminders
}
