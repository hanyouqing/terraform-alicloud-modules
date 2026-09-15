output "load_balancer_id" {
  description = "NLB ID"
  value       = module.nlb.load_balancer_id
}

output "dns_name" {
  description = "NLB DNS name"
  value       = module.nlb.dns_name
}

output "listener_ids" {
  description = "Listener IDs"
  value       = module.nlb.listener_ids
}

output "server_group_ids" {
  description = "Server group IDs"
  value       = module.nlb.server_group_ids
}
