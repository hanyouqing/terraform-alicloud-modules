output "bucket_names" {
  description = "Bucket names"
  value       = module.oss.bucket_names
}

output "extranet_endpoints" {
  description = "Extranet endpoints"
  value       = module.oss.extranet_endpoints
}

output "intranet_endpoints" {
  description = "Intranet endpoints"
  value       = module.oss.intranet_endpoints
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.oss.zzz_reminders
}
