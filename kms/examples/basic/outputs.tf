output "key_id" {
  description = "CMK ID"
  value       = module.kms.key_id
}

output "key_arn" {
  description = "CMK ARN"
  value       = module.kms.key_arn
}
