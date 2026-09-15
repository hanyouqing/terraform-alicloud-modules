output "workspace_id" {
  description = "PAI workspace ID"
  value       = module.pai.workspace_id
}

output "dataset_ids" {
  description = "Dataset IDs"
  value       = module.pai.dataset_ids
}

output "model_ids" {
  description = "Model IDs"
  value       = module.pai.model_ids
}

output "service_ids" {
  description = "Service IDs"
  value       = module.pai.service_ids
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.pai.zzz_reminders
}
