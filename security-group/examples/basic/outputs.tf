output "security_group_id" {
  description = "Security group ID"
  value       = module.security_group.security_group_id
}

output "egress_rule_ids" {
  description = "Egress rule IDs"
  value       = module.security_group.egress_rule_ids
}
