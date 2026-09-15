output "instance_ids" {
  description = "Elasticsearch instance IDs"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => v.id }
}

output "domain" {
  description = "Private Elasticsearch domains"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => v.domain }
}

output "port" {
  description = "Elasticsearch ports"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => v.port }
}

output "kibana_domain" {
  description = "Public Kibana domains when present"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => try(v.kibana_domain, null) }
}

output "kibana_private_domain" {
  description = "Private Kibana domains when present"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => try(v.kibana_private_domain, null) }
}

output "kibana_port" {
  description = "Kibana ports when present"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => try(v.kibana_port, null) }
}

output "status" {
  description = "Instance status"
  value       = { for k, v in alicloud_elasticsearch_instance.this : k => v.status }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Elasticsearch module"
  value = {
    next_steps = [
      "Connect from VPC using domain and port outputs",
      "Prefer kibana_private_domain with enable_kibana_private_network=true",
      "Rotate passwords and store them in a secrets manager (KMS/Secrets)",
      "Validate private_whitelist matches your VPC CIDR",
    ]
    verification = [
      "aliyun elasticsearch ListInstance --RegionId <region>",
      "aliyun elasticsearch DescribeInstance --InstanceId ${length(alicloud_elasticsearch_instance.this) > 0 ? values(alicloud_elasticsearch_instance.this)[0].id : "N/A"}",
    ]
    security_notes = [
      "data_node_disk_encrypted defaults to true",
      "enable_public defaults to false",
      "Password is sensitive on the resource attribute; keep it out of VCS",
      "Production complete example uses data_node_amount >= 2",
    ]
    important_resources = {
      instance_count = length(alicloud_elasticsearch_instance.this)
    }
  }
}
