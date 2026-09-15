output "cluster_id" {
  description = "ACK cluster ID"
  value       = module.ack.cluster_id
}

output "connections" {
  description = "API connection endpoints"
  value       = module.ack.connections
}

output "node_pool_ids" {
  description = "Node pool IDs"
  value       = module.ack.node_pool_ids
}

output "rrsa_metadata" {
  description = "RRSA metadata"
  value       = module.ack.rrsa_metadata
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.ack.zzz_reminders
}
