output "domain_names" {
  description = "CDN domain names"
  value       = module.cdn.domain_names
}

output "cname" {
  description = "CDN CNAMEs"
  value       = module.cdn.cname
}

output "config_ids" {
  description = "CDN domain config IDs"
  value       = module.cdn.config_ids
}
