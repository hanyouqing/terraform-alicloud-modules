output "project_ids" {
  description = "MaxCompute project IDs"
  value       = module.maxcompute.project_ids
}

output "project_names" {
  description = "MaxCompute project names"
  value       = module.maxcompute.project_names
}

output "status" {
  description = "Project status"
  value       = module.maxcompute.status
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.maxcompute.zzz_reminders
}
