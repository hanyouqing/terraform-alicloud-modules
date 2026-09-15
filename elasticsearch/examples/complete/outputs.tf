output "instance_ids" {
  description = "Elasticsearch instance IDs"
  value       = module.elasticsearch.instance_ids
}

output "domain" {
  description = "Private domains"
  value       = module.elasticsearch.domain
}

output "port" {
  description = "Ports"
  value       = module.elasticsearch.port
}

output "kibana_private_domain" {
  description = "Private Kibana domains"
  value       = module.elasticsearch.kibana_private_domain
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.elasticsearch.zzz_reminders
}
