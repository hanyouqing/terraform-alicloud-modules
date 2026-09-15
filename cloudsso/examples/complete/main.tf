terraform {
  required_version = ">= 1.14.2"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.292"
    }
  }
}

provider "alicloud" {
  region = var.region
}

module "cloudsso" {
  source = "../.."

  create_directory            = var.create_directory
  directory_id                = var.directory_id
  directory_name              = var.directory_name
  mfa_authentication_status   = var.create_directory ? "Enabled" : null
  scim_synchronization_status = var.enable_scim ? "Enabled" : null
  saml_identity_provider_configuration = var.saml_metadata_document != null ? {
    encoded_metadata_document = var.saml_metadata_document
    sso_status                = "Enabled"
  } : null
  mfa_authentication_setting_info = var.create_directory ? {
    mfa_authentication_advance_settings = "OnlyEnoughTrust"
  } : null
  scim_server_credentials = var.enable_scim ? {
    primary = {
      status = "Enabled"
    }
  } : {}

  users = {
    alice = {
      user_name    = "alice"
      display_name = "Alice"
      email        = var.alice_email
    }
  }

  groups = {
    admins = {
      group_name  = "Admins"
      description = "Organization administrators"
    }
  }

  group_memberships = {
    admins-alice = {
      group_key = "admins"
      user_keys = ["alice"]
    }
  }

  access_configurations = {
    admin = {
      access_configuration_name = "AdministratorAccess"
      description               = "Full admin via system policy"
      session_duration          = 3600
      permission_policies = [{
        permission_policy_name = "AdministratorAccess"
        permission_policy_type = "System"
      }]
    }
    readonly = {
      access_configuration_name = "ReadOnlyCustom"
      description               = "Inline read-only sample"
      permission_policies = [{
        permission_policy_name = "ReadOnlyInline"
        permission_policy_type = "Inline"
        permission_policy_document = jsonencode({
          Version = "1"
          Statement = [{
            Effect   = "Allow"
            Action   = ["*:Describe*", "*:List*", "*:Get*"]
            Resource = ["*"]
          }]
        })
      }]
    }
  }

  access_assignments = var.target_account_id != null ? {
    admins-target = {
      access_configuration_key = "admin"
      principal_type           = "Group"
      principal_group_key      = "admins"
      target_id                = var.target_account_id
      target_type              = "RD-Account"
    }
  } : {}

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
