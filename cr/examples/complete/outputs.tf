output "edition" {
  description = "Registry edition"
  value       = module.cr.edition
}

output "ee_instance_id" {
  description = "EE instance ID"
  value       = module.cr.ee_instance_id
}

output "namespace_names" {
  description = "Namespace names"
  value       = module.cr.namespace_names
}

output "repo_ids" {
  description = "Repository IDs"
  value       = module.cr.repo_ids
}

output "endpoint_acl_policy_ids" {
  description = "Endpoint ACL policy IDs"
  value       = module.cr.endpoint_acl_policy_ids
}
