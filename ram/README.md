# RAM Module

Flexible Resource Access Management (IAM) for Alibaba Cloud: users, roles, policies, groups, and **SAML / OIDC federation**.

## Features

- Users with optional login profile and access keys (sensitive outputs)
- Roles with assume-role documents (service / SAML / OIDC trust)
- Custom policies and attachments to user/role/group
- Groups with membership
- **SAML IdP** (`alicloud_ram_saml_provider`) for single-account console/API federation
- **OIDC IdP** (`alicloud_ims_oidc_provider`) for CI (GitHub Actions, etc.)
- Account alias, password policy, security preference (MFA enforcement)
- Flexible maps for composable IAM layouts

## Production note

Access keys should be rare in production. Prefer:

| Scenario | Module |
|----------|--------|
| Single account + enterprise IdP (Okta / Azure AD) | `ram` SAML provider + federated role |
| CI OIDC (GitHub / Yunxiao) | `ram` OIDC provider + federated role |
| Multi-account Resource Directory SSO | [`cloudsso`](../cloudsso) SAML on directory |

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single role + custom policy attachment |
| `examples/complete` | Users/groups/roles + password/MFA policy; optional SAML/OIDC via variables |

## Usage

```hcl
module "ram" {
  source = "../ram"

  saml_providers = {
    okta = {
      encodedsaml_metadata_document = var.saml_metadata_b64
      description                   = "Okta"
    }
  }

  roles = {
    saml-admin = {
      document = jsonencode({
        Version = "1"
        Statement = [{
          Effect = "Allow"
          Action = "sts:AssumeRoleWithSAML"
          Principal = {
            Federated = ["acs:ram::${var.account_id}:saml-provider/okta"]
          }
        }]
      })
    }
  }

  password_policy = {
    minimum_password_length      = 12
    require_lowercase_characters = true
    require_uppercase_characters = true
    require_numbers              = true
    require_symbols              = true
  }

  security_preference = {
    enforce_mfa_for_login            = true
    allow_user_to_manage_access_keys = false
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
