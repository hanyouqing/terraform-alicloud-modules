output "instance_id" {
  description = "Kafka instance ID"
  value       = module.kafka.instance_id
}

output "topic_names" {
  description = "Topic names"
  value       = module.kafka.topic_names
}

output "end_point" {
  description = "Endpoint"
  value       = module.kafka.end_point
}
