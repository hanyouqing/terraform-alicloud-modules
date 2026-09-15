output "directory_id" {
  description = "Resource Directory ID (when create_resource_directory is true)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].id, null)
}

output "root_folder_id" {
  description = "Root folder ID of the Resource Directory (when created here)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].root_folder_id, null)
}

output "master_account_id" {
  description = "Master/management account ID (when RD is created here)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].master_account_id, null)
}

output "folder_ids" {
  description = "Map of folder keys to folder IDs"
  value       = local.folder_ids
}

output "account_ids" {
  description = "Map of member account keys to account IDs"
  value       = { for k, v in alicloud_resource_manager_account.member : k => v.id }
}

output "policy_ids" {
  description = "Map of baseline control policy keys to policy IDs"
  value       = { for k, v in alicloud_resource_manager_control_policy.baseline : k => v.id }
}

output "delegated_administrator_ids" {
  description = "Map of delegated administrator resource IDs"
  value       = { for k, v in alicloud_resource_manager_delegated_administrator.this : k => v.id }
}

output "zzz_reminders" {
  description = "Landing Zone next steps after applying this blueprint on the management account"
  value = [
    "Run this module only on the management/master account of the Resource Directory.",
    "Enable CloudSSO (or pair with a future cloudsso module) for federated access to member accounts.",
    "Deploy config aggregator (config module) in the security/audit account for multi-account compliance.",
    "Create an organization ActionTrail trail (actiontrail module) delivering to OSS in the log/security account.",
    "Provision shared networking (vpc module) in log/security/shared-services accounts; attach via CEN when needed.",
    "For advanced RD day-2 ops (invites, custom SCPs, folder moves), pair with a dedicated resource-directory module.",
    "Organize billing and resource ownership with resource-group modules inside each member account.",
  ]
}
