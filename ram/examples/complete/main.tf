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

module "ram" {
  source = "../.."

  users = {
    deployer = {
      display_name         = "Deployer"
      comments             = "CI deployer — prefer OIDC/STS in production"
      create_login_profile = false
      create_access_key    = var.create_access_key
    }
  }

  groups = {
    ops = {
      comments = "Operations group"
    }
  }

  group_memberships = {
    ops-members = {
      group_key = "ops"
      user_keys = ["deployer"]
    }
  }

  roles = merge(
    {
      ecs-app = {
        description = "ECS application role"
        document = jsonencode({
          Statement = [{
            Effect    = "Allow"
            Action    = "sts:AssumeRole"
            Principal = { Service = ["ecs.aliyuncs.com"] }
          }]
          Version = "1"
        })
      }
    },
    var.saml_metadata_document != null && var.account_id != null ? {
      saml-admin = {
        description = "Federated admin via RAM SAML IdP"
        document = jsonencode({
          Version = "1"
          Statement = [{
            Effect = "Allow"
            Action = "sts:AssumeRoleWithSAML"
            Principal = {
              Federated = ["acs:ram::${var.account_id}:saml-provider/${coalesce(var.saml_provider_name, "enterprise-idp")}"]
            }
            Condition = {
              StringEquals = {
                "saml:recipient" = "https://signin.aliyun.com/saml-role/sso"
              }
            }
          }]
        })
      }
    } : {},
    var.oidc_issuer_url != null && var.account_id != null ? {
      oidc-ci = {
        description = "CI via OIDC IdP"
        document = jsonencode({
          Version = "1"
          Statement = [{
            Effect = "Allow"
            Action = "sts:AssumeRoleWithOIDC"
            Principal = {
              Federated = ["acs:ram::${var.account_id}:oidc-provider/${coalesce(var.oidc_provider_name, "github")}"]
            }
            Condition = {
              StringEquals = {
                "oidc:aud" = var.oidc_audiences
              }
            }
          }]
        })
      }
    } : {}
  )

  policies = {
    oss-readonly = {
      policy_document = jsonencode({
        Statement = [{
          Effect   = "Allow"
          Action   = ["oss:GetObject"]
          Resource = ["acs:oss:*:*:${var.bucket_name}/*"]
        }]
        Version = "1"
      })
    }
  }

  user_policy_attachments = {
    deployer-oss = {
      user_key   = "deployer"
      policy_key = "oss-readonly"
    }
  }

  role_policy_attachments = merge(
    {
      ecs-oss = {
        role_key   = "ecs-app"
        policy_key = "oss-readonly"
      }
    },
    var.saml_metadata_document != null && var.account_id != null ? {
      saml-admin-oss = {
        role_key   = "saml-admin"
        policy_key = "oss-readonly"
      }
    } : {}
  )

  group_policy_attachments = {
    ops-oss = {
      group_key  = "ops"
      policy_key = "oss-readonly"
    }
  }

  saml_providers = var.saml_metadata_document != null ? {
    enterprise-idp = {
      saml_provider_name            = var.saml_provider_name
      encodedsaml_metadata_document = var.saml_metadata_document
      description                   = "Enterprise SAML IdP"
    }
  } : {}

  oidc_providers = var.oidc_issuer_url != null ? {
    github = {
      oidc_provider_name = var.oidc_provider_name
      issuer_url         = var.oidc_issuer_url
      client_ids         = var.oidc_audiences
      fingerprints       = var.oidc_fingerprints
      description        = "OIDC IdP for CI"
    }
  } : {}

  password_policy = {
    minimum_password_length      = 12
    require_lowercase_characters = true
    require_uppercase_characters = true
    require_numbers              = true
    require_symbols              = true
    max_password_age             = 90
    password_reuse_prevention    = 5
  }

  security_preference = {
    enforce_mfa_for_login            = true
    allow_user_to_manage_mfa_devices = true
    allow_user_to_manage_access_keys = false
    allow_user_to_change_password    = true
  }

  project     = "alicloud-modules"
  environment = "production"
}
