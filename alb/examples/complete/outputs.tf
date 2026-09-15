output "load_balancer_id" {
  description = "ALB ID"
  value       = module.alb.load_balancer_id
}

output "dns_name" {
  description = "ALB DNS name"
  value       = module.alb.dns_name
}

output "listener_ids" {
  description = "Listener IDs"
  value       = module.alb.listener_ids
}

output "server_group_ids" {
  description = "Server group IDs"
  value       = module.alb.server_group_ids
}
