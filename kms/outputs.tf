output "key_id" {
  description = "ID of the KMS CMK"
  value       = alicloud_kms_key.this.id
}

output "key_arn" {
  description = "ARN of the KMS CMK when available"
  value       = try(alicloud_kms_key.this.arn, null)
}

output "alias" {
  description = "KMS alias name when created"
  value       = var.create_alias ? alicloud_kms_alias.this[0].alias_name : null
}

output "secret_ids" {
  description = "Map of secret IDs (never secret values)"
  value       = { for k, v in alicloud_kms_secret.this : k => v.id }
}

output "secret_names" {
  description = "Map of secret names"
  value       = { for k, v in alicloud_kms_secret.this : k => v.secret_name }
}

output "zzz_reminders" {
  description = "Operational reminders for KMS"
  value = {
    next_steps = [
      "Grant least-privilege kms:Encrypt/Decrypt via RAM to consumers",
      "Enable automatic_rotation for long-lived symmetric CMKs where supported"
    ]
    security_notes = [
      "Secret values are never outputted by this module",
      "pending_window_in_days delays irreversible key deletion"
    ]
    cost_optimization = [
      "CMKs and API calls are billed; avoid unused aliases and secrets"
    ]
    important_resources = {
      key_id       = alicloud_kms_key.this.id
      alias        = var.create_alias ? alicloud_kms_alias.this[0].alias_name : null
      secret_count = length(alicloud_kms_secret.this)
    }
  }
}
