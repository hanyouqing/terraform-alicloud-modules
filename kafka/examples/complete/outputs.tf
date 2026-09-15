output "instance_id" {
  description = "Kafka instance ID"
  value       = module.kafka.instance_id
}

output "topic_names" {
  description = "Topic names"
  value       = module.kafka.topic_names
}

output "vpc_sasl_domain_endpoint" {
  description = "VPC SASL endpoint"
  value       = module.kafka.vpc_sasl_domain_endpoint
}

output "zzz_reminders" {
  description = "Reminders"
  value       = module.kafka.zzz_reminders
}
