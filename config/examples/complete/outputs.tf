output "rule_ids" {
  description = "Single-account rule IDs"
  value       = module.config.rule_ids
}

output "compliance_pack_id" {
  description = "Compliance pack ID"
  value       = module.config.compliance_pack_id
}

output "aggregator_id" {
  description = "Aggregator ID when enabled"
  value       = module.config.aggregator_id
}

output "aggregate_rule_ids" {
  description = "Aggregate rule IDs when enabled"
  value       = module.config.aggregate_rule_ids
}
