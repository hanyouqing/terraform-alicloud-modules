output "project_name" {
  description = "SLS project name"
  value       = module.sls.project_name
}

output "store_names" {
  description = "Log store names"
  value       = module.sls.store_names
}
