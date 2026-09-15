output "directory_id" {
  description = "Resource Directory ID (when create_resource_directory is true)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].id, null)
}

output "root_folder_id" {
  description = "Root folder ID of the Resource Directory (when created by this module)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].root_folder_id, null)
}

output "master_account_id" {
  description = "Master account ID (when directory is created by this module)"
  value       = try(alicloud_resource_manager_resource_directory.this[0].master_account_id, null)
}

output "folder_ids" {
  description = "Map of folder keys to folder IDs (root + one-level children)"
  value       = local.folder_ids
}

output "account_ids" {
  description = "Map of account keys to account IDs"
  value       = { for k, v in alicloud_resource_manager_account.this : k => v.id }
}

output "account_display_names" {
  description = "Map of account keys to display names"
  value       = { for k, v in alicloud_resource_manager_account.this : k => v.display_name }
}

output "policy_ids" {
  description = "Map of control policy keys to policy IDs"
  value       = { for k, v in alicloud_resource_manager_control_policy.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for Resource Directory"
  value = {
    next_steps = [
      "Run only on the master (management) account",
      "Enable Control Policy feature in the console before attaching policies if required",
      "For nesting deeper than one level, pass parent_folder_id from folder_ids in a second apply"
    ]
    security_notes = [
      "Member account creation is difficult to reverse; review display names and folders carefully",
      "Control policies can lock out accounts — start with deny-list on non-production folders"
    ]
    production_note = "Resource Directory exists once per master account; set create_resource_directory=false when reusing an existing directory."
    important_resources = {
      directory_created = var.create_resource_directory
      folder_count      = length(local.folder_ids)
      account_count     = length(alicloud_resource_manager_account.this)
      policy_count      = length(alicloud_resource_manager_control_policy.this)
      attachment_count  = length(alicloud_resource_manager_control_policy_attachment.this)
      delegated_admins  = length(alicloud_resource_manager_delegated_administrator.this)
    }
  }
}
