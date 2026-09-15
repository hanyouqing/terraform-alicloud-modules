output "directory_id" {
  description = "Resource Directory ID"
  value       = module.resource_directory.directory_id
}

output "folder_ids" {
  description = "Folder IDs"
  value       = module.resource_directory.folder_ids
}

output "account_ids" {
  description = "Member account IDs"
  value       = module.resource_directory.account_ids
}

output "policy_ids" {
  description = "Control policy IDs"
  value       = module.resource_directory.policy_ids
}
