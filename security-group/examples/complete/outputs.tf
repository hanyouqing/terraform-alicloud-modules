output "security_group_id" {
  description = "Security group ID"
  value       = module.security_group.security_group_id
}

output "ingress_rule_ids" {
  description = "Ingress rule IDs"
  value       = module.security_group.ingress_rule_ids
}

output "egress_rule_ids" {
  description = "Egress rule IDs"
  value       = module.security_group.egress_rule_ids
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.security_group.zzz_reminders
}
