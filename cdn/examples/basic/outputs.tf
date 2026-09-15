output "domain_names" {
  description = "CDN domain names"
  value       = module.cdn.domain_names
}

output "cname" {
  description = "CDN CNAMEs"
  value       = module.cdn.cname
}
