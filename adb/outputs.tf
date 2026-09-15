output "cluster_ids" {
  description = "AnalyticDB lake-version cluster IDs"
  value       = { for k, v in alicloud_adb_db_cluster_lake_version.this : k => v.id }
}

output "connection_strings" {
  description = "Cluster connection strings"
  value       = { for k, v in alicloud_adb_db_cluster_lake_version.this : k => v.connection_string }
}

output "ports" {
  description = "Cluster ports"
  value       = { for k, v in alicloud_adb_db_cluster_lake_version.this : k => v.port }
}

output "statuses" {
  description = "Cluster status"
  value       = { for k, v in alicloud_adb_db_cluster_lake_version.this : k => v.status }
}

output "account_names" {
  description = "Lake account names"
  value       = { for k, v in alicloud_adb_lake_account.this : k => v.account_name }
}

output "zzz_reminders" {
  description = "Important reminders for AnalyticDB lake clusters"
  value = {
    next_steps = [
      "Connect via connection_string and port from within the VPC",
      "Keep security_ips limited to VPC CIDR",
      "Store account passwords in KMS/Secrets Manager",
    ]
    security_notes = [
      "disk_encryption defaults to true",
      "enable_ssl defaults to true when supported",
      "Provider has no tags on lake cluster; module_tags retained for consistency",
      "Accounts use alicloud_adb_lake_account (lake version); map is not wholly sensitive",
    ]
    important_resources = {
      cluster_count = length(alicloud_adb_db_cluster_lake_version.this)
      account_count = length(alicloud_adb_lake_account.this)
      module_tags   = local.module_tags
    }
  }
}
