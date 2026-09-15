output "directory_id" {
  description = "CloudSSO directory ID (created or provided)"
  value       = local.directory_id
}

output "user_ids" {
  description = "Map of user keys to CloudSSO user IDs"
  value       = { for k, v in alicloud_cloud_sso_user.this : k => v.user_id }
}

output "user_names" {
  description = "Map of user keys to user names"
  value       = { for k, v in alicloud_cloud_sso_user.this : k => v.user_name }
}

output "group_ids" {
  description = "Map of group keys to CloudSSO group IDs"
  value       = { for k, v in alicloud_cloud_sso_group.this : k => v.group_id }
}

output "access_configuration_ids" {
  description = "Map of access configuration keys to IDs"
  value = {
    for k, v in alicloud_cloud_sso_access_configuration.this : k => v.access_configuration_id
  }
}

output "access_assignment_ids" {
  description = "Map of access assignment keys to resource IDs"
  value       = { for k, v in alicloud_cloud_sso_access_assignment.this : k => v.id }
}

output "scim_credential_ids" {
  description = "Map of SCIM server credential IDs"
  value       = { for k, v in alicloud_cloud_sso_scim_server_credential.this : k => v.credential_id }
}

output "saml_service_provider" {
  description = "CloudSSO SAML SP details when directory is created (use ACS/entity in IdP)"
  value = var.create_directory ? try({
    acs_url                   = alicloud_cloud_sso_directory.this[0].saml_service_provider[0].acs_url
    entity_id                 = alicloud_cloud_sso_directory.this[0].saml_service_provider[0].entity_id
    encoded_metadata_document = alicloud_cloud_sso_directory.this[0].saml_service_provider[0].encoded_metadata_document
  }, null) : null
}

output "zzz_reminders" {
  description = "Operational reminders for CloudSSO"
  value = {
    next_steps = [
      "Enable CloudSSO on the Resource Directory master account before creating a directory",
      "Configure external SAML IdP via saml_identity_provider_configuration (metadata) and register CloudSSO SP ACS/entity in the IdP",
      "Enable SCIM (scim_synchronization_status + scim_server_credentials) for automated user sync",
      "Assign access configurations to member account IDs (RD-Account target_type)",
      "Single-account SAML without RD: use ram module saml_providers instead"
    ]
    security_notes = [
      "User passwords in Terraform state are sensitive — rotate and prefer SAML federation",
      "SCIM credential secrets may be written to credential_secret_file — protect that path",
      "Review System vs Inline permission policies for least privilege"
    ]
    production_note = "CloudSSO directory is typically unique per organization; set create_directory=false when reusing an existing directory_id. SAML IdP nested settings require managing the directory resource (create or import)."
    important_resources = {
      directory_created          = var.create_directory
      saml_idp_configured        = var.saml_identity_provider_configuration != null
      user_count                 = length(alicloud_cloud_sso_user.this)
      group_count                = length(alicloud_cloud_sso_group.this)
      membership_count           = length(alicloud_cloud_sso_user_attachment.this)
      access_configuration_count = length(alicloud_cloud_sso_access_configuration.this)
      assignment_count           = length(alicloud_cloud_sso_access_assignment.this)
      scim_credential_count      = length(alicloud_cloud_sso_scim_server_credential.this)
    }
  }
}
