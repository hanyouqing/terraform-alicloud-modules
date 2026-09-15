output "domain_names" {
  description = "Created public domain names"
  value       = module.dns.domain_names
}

output "record_ids" {
  description = "Public record IDs"
  value       = module.dns.record_ids
}

output "pvtz_zone_ids" {
  description = "PrivateZone IDs"
  value       = module.dns.pvtz_zone_ids
}

output "dns_servers" {
  description = "NS servers for created domains"
  value       = module.dns.dns_servers
}
