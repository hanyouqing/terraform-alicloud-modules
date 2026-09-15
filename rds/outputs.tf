output "instance_ids" {
  description = "RDS instance IDs"
  value       = { for k, v in alicloud_db_instance.this : k => v.id }
}

output "instance_id" {
  description = "Alias of instance_ids"
  value       = { for k, v in alicloud_db_instance.this : k => v.id }
}

output "connection_strings" {
  description = "Private connection strings"
  value       = { for k, v in alicloud_db_instance.this : k => v.connection_string }
}

output "connection_string" {
  description = "Alias of connection_strings"
  value       = { for k, v in alicloud_db_instance.this : k => v.connection_string }
}

output "ports" {
  description = "Database ports"
  value       = { for k, v in alicloud_db_instance.this : k => v.port }
}

output "port" {
  description = "Alias of ports"
  value       = { for k, v in alicloud_db_instance.this : k => v.port }
}

output "engine_versions" {
  description = "Engine versions in use"
  value       = { for k, v in alicloud_db_instance.this : k => "${v.engine} ${v.engine_version}" }
}

output "account_ids" {
  description = "Created DB account IDs"
  value       = { for k, v in alicloud_rds_account.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the RDS module"
  value = {
    next_steps = [
      "Connect via the private connection string from VPC workloads only",
      "Rotate account passwords and store them in KMS/Secrets Manager",
      "Confirm backup windows and retention meet RPO/RTO targets",
      "Enable monitoring/alerting for CPU, storage, and connections",
    ]
    verification = [
      "aliyun rds DescribeDBInstances --RegionId <region>",
      "aliyun rds DescribeDBInstanceAttribute --DBInstanceId ${length(alicloud_db_instance.this) > 0 ? values(alicloud_db_instance.this)[0].id : "N/A"}",
    ]
    security_notes = [
      "security_ips defaults to VPC-oriented CIDR (override per instance as needed)",
      "SSL defaults to Open",
      "Prefer private vswitch_id; avoid classic network",
      "Use encryption_key / tde_status for disk/TDE encryption where supported",
      "deletion_protection defaults to true",
    ]
    important_resources = {
      instance_count  = length(alicloud_db_instance.this)
      account_count   = length(alicloud_rds_account.this)
      backup_policies = length(alicloud_db_backup_policy.this)
    }
  }
}
