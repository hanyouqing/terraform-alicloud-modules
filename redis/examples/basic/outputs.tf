output "instance_ids" {
  description = "Redis instance IDs"
  value       = module.redis.instance_ids
}

output "connection_domains" {
  description = "Connection domains"
  value       = module.redis.connection_domains
}

output "ports" {
  description = "Ports"
  value       = module.redis.ports
}
