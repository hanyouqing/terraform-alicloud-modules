output "domain_names" {
  description = "Map of created public Alidns domain names"
  value       = { for k, v in alicloud_alidns_domain.this : k => v.domain_name }
}

output "domain_ids" {
  description = "Map of created public Alidns domain IDs"
  value       = { for k, v in alicloud_alidns_domain.this : k => v.domain_id }
}

output "dns_servers" {
  description = "Map of DNS servers for created domains"
  value       = { for k, v in alicloud_alidns_domain.this : k => v.dns_servers }
}

output "record_ids" {
  description = "Map of public Alidns record IDs"
  value       = { for k, v in alicloud_alidns_record.this : k => v.id }
}

output "pvtz_zone_ids" {
  description = "Map of PrivateZone zone IDs"
  value       = { for k, v in alicloud_pvtz_zone.this : k => v.id }
}

output "pvtz_record_ids" {
  description = "Map of PrivateZone record IDs"
  value       = { for k, v in alicloud_pvtz_zone_record.this : k => v.id }
}

output "pvtz_attachment_ids" {
  description = "Map of PrivateZone VPC attachment IDs"
  value       = { for k, v in alicloud_pvtz_zone_attachment.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for DNS / PrivateZone"
  value = {
    next_steps = [
      "Delegate registrar NS to Alidns dns_servers for newly added public domains",
      "Attach PrivateZone zones to application VPCs via vpc_ids",
      "Prefer alicloud_alidns_* resources; avoid deprecated alicloud_dns_*"
    ]
    security_notes = [
      "Lock down who can modify DNS via RAM; DNS changes are high impact",
      "Use short TTL only during cutovers; restore production TTL afterward"
    ]
    cost_optimization = [
      "PrivateZone is billed per zone and queries; remove unused attachments",
      "Avoid duplicate public + private records unless required for hybrid resolution"
    ]
    important_resources = {
      public_domain_count = length(alicloud_alidns_domain.this)
      public_record_count = length(alicloud_alidns_record.this)
      pvtz_zone_count     = length(alicloud_pvtz_zone.this)
      pvtz_record_count   = length(alicloud_pvtz_zone_record.this)
    }
  }
}
