output "domain_names" {
  description = "Map of CDN accelerated domain names"
  value       = { for k, v in alicloud_cdn_domain_new.this : k => v.domain_name }
}

output "cname" {
  description = "Map of CDN CNAME values for DNS cutover"
  value       = { for k, v in alicloud_cdn_domain_new.this : k => v.cname }
}

output "domain_ids" {
  description = "Map of CDN domain resource IDs"
  value       = { for k, v in alicloud_cdn_domain_new.this : k => v.id }
}

output "config_ids" {
  description = "Map of CDN domain config IDs"
  value       = { for k, v in alicloud_cdn_domain_config.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for CDN"
  value = {
    next_steps = [
      "Create a CNAME DNS record from domain_name to the exported cname",
      "Complete ICP filing requirements for domestic / global scope domains",
      "Configure HTTPS certificates and cache rules via domain configs"
    ]
    security_notes = [
      "Prefer HTTPS origin and enable force HTTPS / HSTS via CDN configs",
      "Use IP allow/block lists carefully; prefer WAF in front for app-layer threats"
    ]
    cost_optimization = [
      "Choose scope (domestic/overseas/global) based on audience to avoid unnecessary billing",
      "Tune cache TTLs to reduce origin traffic"
    ]
    important_resources = {
      domain_count = length(alicloud_cdn_domain_new.this)
      config_count = length(alicloud_cdn_domain_config.this)
      cnames       = { for k, v in alicloud_cdn_domain_new.this : k => v.cname }
    }
  }
}
