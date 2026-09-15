output "cluster_id" {
  description = "ACK cluster ID"
  value       = module.ack.cluster_id
}

output "node_pool_ids" {
  description = "Node pool IDs"
  value       = module.ack.node_pool_ids
}

output "connections" {
  description = "API connection endpoints"
  value       = module.ack.connections
}
