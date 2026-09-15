output "instance_ids" {
  description = "KVStore (Redis/Tair) instance IDs"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.id }
}

output "instance_id" {
  description = "Alias of instance_ids"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.id }
}

output "connection_domains" {
  description = "Intranet connection domains"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.connection_domain }
}

output "connection_domain" {
  description = "Alias of connection_domains"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.connection_domain }
}

output "ports" {
  description = "Instance ports"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.port }
}

output "port" {
  description = "Alias of ports"
  value       = { for k, v in alicloud_kvstore_instance.this : k => v.port }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Redis module"
  value = {
    next_steps = [
      "Connect using connection_domain from VPC workloads",
      "Rotate Redis passwords and store them in a secrets manager",
      "Validate backup_period and maintain windows for your workload",
      "Confirm SSL and vpc_auth_mode match application client settings",
    ]
    verification = [
      "aliyun r-kvstore DescribeInstances --RegionId <region>",
      "aliyun r-kvstore DescribeInstanceAttribute --InstanceId ${length(alicloud_kvstore_instance.this) > 0 ? values(alicloud_kvstore_instance.this)[0].id : "N/A"}",
    ]
    security_notes = [
      "vpc_auth_mode defaults to Open (password required)",
      "ssl_enable defaults to Enable where supported",
      "Prefer private vswitch_id and VPC CIDR security_ips",
      "Never commit passwords to version control",
    ]
    important_resources = {
      instance_count = length(alicloud_kvstore_instance.this)
    }
  }
}
