output "directory_id" {
  description = "CloudSSO directory ID"
  value       = module.cloudsso.directory_id
}

output "user_ids" {
  description = "User IDs"
  value       = module.cloudsso.user_ids
}

output "group_ids" {
  description = "Group IDs"
  value       = module.cloudsso.group_ids
}
