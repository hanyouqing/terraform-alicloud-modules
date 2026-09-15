output "namespace_names" {
  description = "Namespace names"
  value       = module.cr.namespace_names
}

output "repo_ids" {
  description = "Repository IDs"
  value       = module.cr.repo_ids
}

output "edition" {
  description = "Registry edition"
  value       = module.cr.edition
}
