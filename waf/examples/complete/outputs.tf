output "instance_id" {
  description = "WAFv3 instance ID"
  value       = module.waf.instance_id
}

output "domain_ids" {
  description = "WAFv3 domain IDs"
  value       = module.waf.domain_ids
}

output "cnames" {
  description = "WAF CNAMEs"
  value       = module.waf.cnames
}
