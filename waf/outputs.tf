output "instance_id" {
  description = "WAFv3 instance ID (created or supplied)"
  value       = local.instance_id
}

output "domain_ids" {
  description = "Map of WAFv3 domain IDs"
  value       = { for k, v in alicloud_wafv3_domain.this : k => v.domain_id }
}

output "domain_names" {
  description = "Map of WAFv3 protected domain names"
  value       = { for k, v in alicloud_wafv3_domain.this : k => v.domain }
}

output "cnames" {
  description = "Map of WAF-assigned CNAMEs for DNS cutover"
  value       = { for k, v in alicloud_wafv3_domain.this : k => v.cname }
}

output "zzz_reminders" {
  description = "Operational reminders for WAFv3"
  value = {
    next_steps = [
      "Point public DNS CNAME records to the exported WAF cnames",
      "Prefer create_instance=false with an existing paid instance_id in examples/CI",
      "Configure defense rules in console or a dedicated follow-up module when needed"
    ]
    security_notes = [
      "WAFv3 instance creation is a paid product; destroy carefully",
      "Keep HTTPS cert_id current; enable TLS 1.2+ in listen settings"
    ]
    cost_optimization = [
      "Reuse one WAFv3 instance across domains instead of creating multiple instances",
      "Right-size edition/capacity outside Terraform if purchased via console/marketplace"
    ]
    important_resources = {
      instance_id  = local.instance_id
      domain_count = length(alicloud_wafv3_domain.this)
      created_here = var.create_instance
    }
  }
}
