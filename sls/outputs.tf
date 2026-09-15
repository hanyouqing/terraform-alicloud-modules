output "project_name" {
  description = "Name of the SLS project"
  value       = alicloud_log_project.this.project_name
}

output "project_id" {
  description = "ID of the SLS project"
  value       = alicloud_log_project.this.id
}

output "store_names" {
  description = "Map of log store names"
  value       = { for k, v in alicloud_log_store.this : k => v.logstore_name }
}

output "store_ids" {
  description = "Map of log store IDs"
  value       = { for k, v in alicloud_log_store.this : k => v.id }
}

output "index_ids" {
  description = "Map of log store index IDs when created"
  value       = { for k, v in alicloud_log_store_index.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for SLS"
  value = {
    next_steps = [
      "Configure Logtail / SDK ingestion to the created log stores",
      "Create indexes for fields you query frequently"
    ]
    security_notes = [
      "Restrict project ACL / RAM policies for read and write principals",
      "Consider encrypt_conf with a CMK for sensitive logs"
    ]
    cost_optimization = [
      "Right-size retention_period and shard_count",
      "Disable unused indexes to reduce indexing cost"
    ]
    important_resources = {
      project_name = alicloud_log_project.this.project_name
      store_count  = length(alicloud_log_store.this)
      index_count  = length(alicloud_log_store_index.this)
    }
  }
}
