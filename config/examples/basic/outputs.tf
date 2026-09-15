output "configuration_recorder_id" {
  description = "Configuration recorder ID"
  value       = module.config.configuration_recorder_id
}

output "rule_ids" {
  description = "Config rule IDs"
  value       = module.config.rule_ids
}
