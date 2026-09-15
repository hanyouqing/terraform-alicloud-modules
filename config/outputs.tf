output "configuration_recorder_id" {
  description = "Configuration recorder ID (account ID) when created"
  value       = try(alicloud_config_configuration_recorder.this[0].id, null)
}

output "configuration_recorder_status" {
  description = "Configuration recorder status when created"
  value       = try(alicloud_config_configuration_recorder.this[0].status, null)
}

output "rule_ids" {
  description = "Map of single-account config rule IDs"
  value       = { for k, v in alicloud_config_rule.this : k => v.id }
}

output "rule_arns" {
  description = "Map of single-account config rule ARNs"
  value       = { for k, v in alicloud_config_rule.this : k => v.config_rule_arn }
}

output "compliance_pack_id" {
  description = "Compliance pack ID when created"
  value       = try(alicloud_config_compliance_pack.this[0].id, null)
}

output "aggregator_id" {
  description = "Aggregator ID (created or existing)"
  value       = local.aggregator_id
}

output "aggregate_rule_ids" {
  description = "Map of aggregate config rule IDs"
  value       = { for k, v in alicloud_config_aggregate_config_rule.this : k => v.id }
}

output "common_tags" {
  description = "Merged tagging convention for this module"
  value       = local.common_tags
}
