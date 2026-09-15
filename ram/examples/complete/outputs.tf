output "user_ids" {
  description = "User IDs"
  value       = module.ram.user_ids
}

output "role_arns" {
  description = "Role ARNs"
  value       = module.ram.role_arns
}

output "policy_names" {
  description = "Policy names"
  value       = module.ram.policy_names
}

output "group_names" {
  description = "Group names"
  value       = module.ram.group_names
}

output "access_key_ids" {
  description = "Access key IDs (sensitive)"
  value       = module.ram.access_key_ids
  sensitive   = true
}
