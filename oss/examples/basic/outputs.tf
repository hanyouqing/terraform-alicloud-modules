output "bucket_names" {
  description = "Bucket names"
  value       = module.oss.bucket_names
}

output "intranet_endpoints" {
  description = "Intranet endpoints"
  value       = module.oss.intranet_endpoints
}
