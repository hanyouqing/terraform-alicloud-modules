output "key_id" {
  description = "CMK ID"
  value       = module.kms.key_id
}

output "alias" {
  description = "KMS alias"
  value       = module.kms.alias
}

output "secret_ids" {
  description = "Secret IDs (not values)"
  value       = module.kms.secret_ids
}
