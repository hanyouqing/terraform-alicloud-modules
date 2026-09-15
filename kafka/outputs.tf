output "instance_id" {
  description = "Kafka instance ID"
  value       = local.instance_id
}

output "end_point" {
  description = "Default endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].end_point, null)
}

output "domain_endpoint" {
  description = "Domain endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].domain_endpoint, null)
}

output "ssl_endpoint" {
  description = "SSL endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].ssl_endpoint, null)
}

output "ssl_domain_endpoint" {
  description = "SSL domain endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].ssl_domain_endpoint, null)
}

output "sasl_domain_endpoint" {
  description = "SASL domain endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].sasl_domain_endpoint, null)
}

output "vpc_sasl_domain_endpoint" {
  description = "VPC SASL domain endpoint when available"
  value       = try(alicloud_alikafka_instance.this[0].vpc_sasl_domain_endpoint, null)
}

output "topic_names" {
  description = "Kafka topic names"
  value       = { for k, v in alicloud_alikafka_topic.this : k => v.topic }
}

output "consumer_group_ids" {
  description = "Consumer group IDs"
  value       = { for k, v in alicloud_alikafka_consumer_group.this : k => v.id }
}

output "sasl_usernames" {
  description = "SASL usernames"
  value       = { for k, v in alicloud_alikafka_sasl_user.this : k => v.username }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Kafka module"
  value = {
    next_steps = [
      "Use VPC endpoints (deploy_type=5) from application workloads",
      "Create ACLs for SASL users when enabling authentication",
      "Prefer multi-zone vswitch_ids for production",
      "Store SASL passwords in a secrets manager",
    ]
    verification = [
      "aliyun alikafka GetInstanceList --RegionId <region>",
      "aliyun alikafka GetTopicList --InstanceId ${local.instance_id != null ? local.instance_id : "N/A"}",
    ]
    security_notes = [
      "Set kms_key_id for disk encryption when required",
      "Attach a least-privilege security_group",
      "SASL password is sensitive on the resource; map is not wholly sensitive",
    ]
    important_resources = {
      topic_count          = length(alicloud_alikafka_topic.this)
      consumer_group_count = length(alicloud_alikafka_consumer_group.this)
      sasl_user_count      = length(alicloud_alikafka_sasl_user.this)
    }
  }
}
