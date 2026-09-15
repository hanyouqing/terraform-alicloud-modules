locals {
  users_needing_access_key = {
    for k, v in var.users : k => v if v.create_access_key
  }

  users_needing_login = {
    for k, v in var.users : k => v if v.create_login_profile
  }

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

resource "alicloud_ram_user" "this" {
  for_each = var.users

  name         = coalesce(each.value.name, each.key)
  display_name = each.value.display_name
  mobile       = each.value.mobile
  email        = each.value.email
  comments     = each.value.comments
}

resource "alicloud_ram_login_profile" "this" {
  for_each = local.users_needing_login

  user_name               = alicloud_ram_user.this[each.key].name
  password                = each.value.password
  password_reset_required = each.value.password_reset_required
  mfa_bind_required       = each.value.mfa_bind_required
}

resource "alicloud_ram_access_key" "this" {
  for_each = local.users_needing_access_key

  user_name = alicloud_ram_user.this[each.key].name
  status    = each.value.access_key_status
}

resource "alicloud_ram_role" "this" {
  for_each = var.roles

  role_name                   = coalesce(each.value.name, each.key)
  assume_role_policy_document = each.value.document
  description                 = each.value.description
  max_session_duration        = each.value.max_session_duration
  force                       = each.value.force
}

resource "alicloud_ram_policy" "this" {
  for_each = var.policies

  policy_name     = coalesce(each.value.policy_name, each.key)
  policy_document = each.value.policy_document
  description     = each.value.description
  rotate_strategy = each.value.rotate_strategy
}

resource "alicloud_ram_group" "this" {
  for_each = var.groups

  group_name = coalesce(each.value.name, each.key)
  comments   = each.value.comments
  force      = true
}

resource "alicloud_ram_user_group_attachment" "this" {
  for_each = local.user_group_attachments

  group_name = alicloud_ram_group.this[each.value.group_key].group_name
  user_name  = alicloud_ram_user.this[each.value.user_key].name
}

resource "alicloud_ram_user_policy_attachment" "this" {
  for_each = var.user_policy_attachments

  user_name   = alicloud_ram_user.this[each.value.user_key].name
  policy_name = each.value.policy_key != null ? alicloud_ram_policy.this[each.value.policy_key].policy_name : each.value.policy_name
  policy_type = each.value.policy_type
}

resource "alicloud_ram_role_policy_attachment" "this" {
  for_each = var.role_policy_attachments

  role_name   = alicloud_ram_role.this[each.value.role_key].role_name
  policy_name = each.value.policy_key != null ? alicloud_ram_policy.this[each.value.policy_key].policy_name : each.value.policy_name
  policy_type = each.value.policy_type
}

resource "alicloud_ram_group_policy_attachment" "this" {
  for_each = var.group_policy_attachments

  group_name  = alicloud_ram_group.this[each.value.group_key].group_name
  policy_name = each.value.policy_key != null ? alicloud_ram_policy.this[each.value.policy_key].policy_name : each.value.policy_name
  policy_type = each.value.policy_type
}

resource "alicloud_ram_saml_provider" "this" {
  for_each = var.saml_providers

  saml_provider_name            = coalesce(each.value.saml_provider_name, each.key)
  encodedsaml_metadata_document = each.value.encodedsaml_metadata_document
  description                   = each.value.description
}

resource "alicloud_ims_oidc_provider" "this" {
  for_each = var.oidc_providers

  oidc_provider_name  = coalesce(each.value.oidc_provider_name, each.key)
  issuer_url          = each.value.issuer_url
  client_ids          = each.value.client_ids
  fingerprints        = each.value.fingerprints
  description         = each.value.description
  issuance_limit_time = each.value.issuance_limit_time
}

resource "alicloud_ram_account_alias" "this" {
  count = var.account_alias != null ? 1 : 0

  account_alias = var.account_alias
}

resource "alicloud_ram_password_policy" "this" {
  count = var.password_policy != null ? 1 : 0

  hard_expiry                          = var.password_policy.hard_expiry
  max_login_attemps                    = var.password_policy.max_login_attemps
  max_password_age                     = var.password_policy.max_password_age
  minimum_password_different_character = var.password_policy.minimum_password_different_character
  minimum_password_length              = var.password_policy.minimum_password_length
  password_not_contain_user_name       = var.password_policy.password_not_contain_user_name
  password_reuse_prevention            = var.password_policy.password_reuse_prevention
  require_lowercase_characters         = var.password_policy.require_lowercase_characters
  require_numbers                      = var.password_policy.require_numbers
  require_symbols                      = var.password_policy.require_symbols
  require_uppercase_characters         = var.password_policy.require_uppercase_characters
}

resource "alicloud_ram_security_preference" "this" {
  count = var.security_preference != null ? 1 : 0

  allow_user_to_change_password           = var.security_preference.allow_user_to_change_password
  allow_user_to_login_with_passkey        = var.security_preference.allow_user_to_login_with_passkey
  allow_user_to_manage_access_keys        = var.security_preference.allow_user_to_manage_access_keys
  allow_user_to_manage_mfa_devices        = var.security_preference.allow_user_to_manage_mfa_devices
  allow_user_to_manage_personal_ding_talk = var.security_preference.allow_user_to_manage_personal_ding_talk
  enable_save_mfa_ticket                  = var.security_preference.enable_save_mfa_ticket
  enforce_mfa_for_login                   = var.security_preference.enforce_mfa_for_login
  login_network_masks                     = var.security_preference.login_network_masks
  login_session_duration                  = var.security_preference.login_session_duration
  max_idle_days_for_access_keys           = var.security_preference.max_idle_days_for_access_keys
  max_idle_days_for_users                 = var.security_preference.max_idle_days_for_users
  mfa_operation_for_login                 = var.security_preference.mfa_operation_for_login
  operation_for_risk_login                = var.security_preference.operation_for_risk_login
  verification_types                      = var.security_preference.verification_types
}
