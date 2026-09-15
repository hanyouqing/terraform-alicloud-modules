locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/cloudsso"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  directory_id = var.create_directory ? alicloud_cloud_sso_directory.this[0].id : var.directory_id

  user_group_attachments = {
    for pair in flatten([
      for mk, m in var.group_memberships : [
        for uk in m.user_keys : {
          key       = "${mk}-${uk}"
          group_key = m.group_key
          user_key  = uk
        }
      ]
    ]) : pair.key => pair
  }
}

resource "alicloud_cloud_sso_directory" "this" {
  count = var.create_directory ? 1 : 0

  directory_name                 = var.directory_name
  mfa_authentication_status      = var.mfa_authentication_status
  scim_synchronization_status    = var.scim_synchronization_status
  directory_global_access_status = var.directory_global_access_status

  dynamic "saml_identity_provider_configuration" {
    for_each = var.saml_identity_provider_configuration != null ? [var.saml_identity_provider_configuration] : []
    content {
      encoded_metadata_document = saml_identity_provider_configuration.value.encoded_metadata_document
      sso_status                = saml_identity_provider_configuration.value.sso_status
      want_request_signed       = saml_identity_provider_configuration.value.want_request_signed
      binding_type              = saml_identity_provider_configuration.value.binding_type
      entity_id                 = saml_identity_provider_configuration.value.entity_id
      login_url                 = saml_identity_provider_configuration.value.login_url
    }
  }

  dynamic "saml_service_provider" {
    for_each = var.saml_service_provider != null ? [var.saml_service_provider] : []
    content {
      authn_sign_algo             = saml_service_provider.value.authn_sign_algo
      certificate_type            = saml_service_provider.value.certificate_type
      support_encrypted_assertion = saml_service_provider.value.support_encrypted_assertion
    }
  }

  dynamic "login_preference" {
    for_each = var.login_preference != null ? [var.login_preference] : []
    content {
      allow_user_to_get_credentials = login_preference.value.allow_user_to_get_credentials
      login_network_masks           = login_preference.value.login_network_masks
    }
  }

  dynamic "mfa_authentication_setting_info" {
    for_each = var.mfa_authentication_setting_info != null ? [var.mfa_authentication_setting_info] : []
    content {
      mfa_authentication_advance_settings = mfa_authentication_setting_info.value.mfa_authentication_advance_settings
      operation_for_risk_login            = mfa_authentication_setting_info.value.operation_for_risk_login
    }
  }

  dynamic "password_policy" {
    for_each = var.password_policy != null ? [var.password_policy] : []
    content {
      max_login_attempts            = password_policy.value.max_login_attempts
      max_password_age              = password_policy.value.max_password_age
      min_password_different_chars  = password_policy.value.min_password_different_chars
      min_password_length           = password_policy.value.min_password_length
      password_not_contain_username = password_policy.value.password_not_contain_username
      password_reuse_prevention     = password_policy.value.password_reuse_prevention
    }
  }

  dynamic "user_provisioning_configuration" {
    for_each = var.user_provisioning_configuration != null ? [var.user_provisioning_configuration] : []
    content {
      default_landing_page = user_provisioning_configuration.value.default_landing_page
      session_duration     = user_provisioning_configuration.value.session_duration
    }
  }
}

resource "alicloud_cloud_sso_scim_server_credential" "this" {
  for_each = var.scim_server_credentials

  directory_id           = local.directory_id
  status                 = each.value.status
  credential_secret_file = each.value.credential_secret_file
}

resource "alicloud_cloud_sso_user" "this" {
  for_each = var.users

  directory_id                = local.directory_id
  user_name                   = each.value.user_name
  display_name                = each.value.display_name
  email                       = each.value.email
  first_name                  = each.value.first_name
  last_name                   = each.value.last_name
  description                 = each.value.description
  status                      = each.value.status
  password                    = each.value.password
  mfa_authentication_settings = each.value.mfa_authentication_settings
  tags                        = merge(local.common_tags, each.value.tags)
}

resource "alicloud_cloud_sso_group" "this" {
  for_each = var.groups

  directory_id = local.directory_id
  group_name   = each.value.group_name
  description  = each.value.description
}

resource "alicloud_cloud_sso_user_attachment" "this" {
  for_each = local.user_group_attachments

  directory_id = local.directory_id
  group_id     = alicloud_cloud_sso_group.this[each.value.group_key].group_id
  user_id      = alicloud_cloud_sso_user.this[each.value.user_key].user_id
}

resource "alicloud_cloud_sso_access_configuration" "this" {
  for_each = var.access_configurations

  directory_id                     = local.directory_id
  access_configuration_name        = each.value.access_configuration_name
  description                      = each.value.description
  session_duration                 = each.value.session_duration
  relay_state                      = each.value.relay_state
  force_remove_permission_policies = each.value.force_remove_permission_policies

  dynamic "permission_policies" {
    for_each = each.value.permission_policies
    content {
      permission_policy_name     = permission_policies.value.permission_policy_name
      permission_policy_type     = permission_policies.value.permission_policy_type
      permission_policy_document = permission_policies.value.permission_policy_document
    }
  }
}

resource "alicloud_cloud_sso_access_assignment" "this" {
  for_each = var.access_assignments

  directory_id = local.directory_id
  access_configuration_id = (
    each.value.access_configuration_key != null
    ? alicloud_cloud_sso_access_configuration.this[each.value.access_configuration_key].access_configuration_id
    : each.value.access_configuration_id
  )
  principal_type = each.value.principal_type
  principal_id = (
    each.value.principal_type == "User"
    ? (
      each.value.principal_user_key != null
      ? alicloud_cloud_sso_user.this[each.value.principal_user_key].user_id
      : each.value.principal_id
    )
    : (
      each.value.principal_group_key != null
      ? alicloud_cloud_sso_group.this[each.value.principal_group_key].group_id
      : each.value.principal_id
    )
  )
  target_id            = each.value.target_id
  target_type          = each.value.target_type
  deprovision_strategy = each.value.deprovision_strategy
}
