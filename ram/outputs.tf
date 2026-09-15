output "user_ids" {
  description = "Map of RAM user IDs"
  value       = { for k, v in alicloud_ram_user.this : k => v.id }
}

output "user_names" {
  description = "Map of RAM user names"
  value       = { for k, v in alicloud_ram_user.this : k => v.name }
}

output "role_arns" {
  description = "Map of RAM role ARNs"
  value       = { for k, v in alicloud_ram_role.this : k => v.arn }
}

output "role_names" {
  description = "Map of RAM role names"
  value       = { for k, v in alicloud_ram_role.this : k => v.role_name }
}

output "policy_names" {
  description = "Map of custom policy names"
  value       = { for k, v in alicloud_ram_policy.this : k => v.policy_name }
}

output "group_names" {
  description = "Map of RAM group names"
  value       = { for k, v in alicloud_ram_group.this : k => v.group_name }
}

output "access_key_ids" {
  description = "Map of access key IDs (sensitive). Prefer roles/SSO in production."
  value       = { for k, v in alicloud_ram_access_key.this : k => v.id }
  sensitive   = true
}

output "access_key_secrets" {
  description = "Map of access key secrets (sensitive). Store in a secrets manager immediately."
  value       = { for k, v in alicloud_ram_access_key.this : k => v.secret }
  sensitive   = true
}

output "saml_provider_arns" {
  description = "Map of RAM SAML provider ARNs"
  value       = { for k, v in alicloud_ram_saml_provider.this : k => v.arn }
}

output "saml_provider_names" {
  description = "Map of RAM SAML provider names"
  value       = { for k, v in alicloud_ram_saml_provider.this : k => v.saml_provider_name }
}

output "oidc_provider_arns" {
  description = "Map of IMS OIDC provider ARNs"
  value       = { for k, v in alicloud_ims_oidc_provider.this : k => v.arn }
}

output "oidc_provider_names" {
  description = "Map of IMS OIDC provider names"
  value       = { for k, v in alicloud_ims_oidc_provider.this : k => v.oidc_provider_name }
}

output "account_alias" {
  description = "RAM account alias when managed"
  value       = try(alicloud_ram_account_alias.this[0].account_alias, null)
}

output "zzz_reminders" {
  description = "Operational reminders for RAM"
  value = {
    next_steps = [
      "Prefer STS assume-role and SSO over long-lived access keys",
      "Register SAML/OIDC IdPs then trust them from RAM roles (AssumeRoleWithSAML / AssumeRoleWithOIDC)",
      "For multi-account org SSO use the cloudsso module (SAML on CloudSSO directory)",
      "Enable MFA via security_preference / login profiles"
    ]
    security_notes = [
      "Access key secrets are sensitive outputs — rotate and store outside state when possible",
      "SAML metadata and OIDC fingerprints are trust anchors — rotate when the IdP rotates certs",
      "Review policy documents for least privilege before production"
    ]
    production_note = "Access keys should be rare in production; use SAML/OIDC federation and temporary credentials."
    important_resources = {
      user_count          = length(alicloud_ram_user.this)
      role_count          = length(alicloud_ram_role.this)
      policy_count        = length(alicloud_ram_policy.this)
      group_count         = length(alicloud_ram_group.this)
      access_keys         = length(alicloud_ram_access_key.this)
      saml_provider_count = length(alicloud_ram_saml_provider.this)
      oidc_provider_count = length(alicloud_ims_oidc_provider.this)
      password_policy     = var.password_policy != null
      security_preference = var.security_preference != null
    }
  }
}
