output "directory_id" {
  description = "CloudSSO directory ID"
  value       = module.cloudsso.directory_id
}

output "user_ids" {
  description = "User IDs"
  value       = module.cloudsso.user_ids
}

output "access_configuration_ids" {
  description = "Access configuration IDs"
  value       = module.cloudsso.access_configuration_ids
}

output "access_assignment_ids" {
  description = "Access assignment IDs"
  value       = module.cloudsso.access_assignment_ids
}
