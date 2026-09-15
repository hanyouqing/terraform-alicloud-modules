output "role_arns" {
  description = "Role ARNs"
  value       = module.ram.role_arns
}

output "policy_names" {
  description = "Policy names"
  value       = module.ram.policy_names
}
