output "instance_ids" {
  description = "Instance IDs"
  value       = module.ecs.instance_ids
}

output "private_ips" {
  description = "Private IPs"
  value       = module.ecs.private_ips
}
