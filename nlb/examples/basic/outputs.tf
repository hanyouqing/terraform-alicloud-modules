output "load_balancer_id" {
  description = "NLB ID"
  value       = module.nlb.load_balancer_id
}

output "dns_name" {
  description = "NLB DNS name"
  value       = module.nlb.dns_name
}
