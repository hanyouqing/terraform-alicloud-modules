output "namespace_names" {
  description = "Namespace names"
  value       = module.cicd.namespace_names
}

output "repo_ids" {
  description = "Repository IDs"
  value       = module.cicd.repo_ids
}

output "ci_role_arn" {
  description = "CI role ARN"
  value       = module.cicd.ci_role_arn
}

output "image_pipeline_ids" {
  description = "Image pipeline IDs"
  value       = module.cicd.image_pipeline_ids
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.cicd.zzz_reminders
}
