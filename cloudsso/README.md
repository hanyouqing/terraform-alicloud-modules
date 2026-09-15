# CloudSSO Module

Multi-account unified identity (CloudSSO) for Alibaba Cloud Resource Directory organizations, including **external SAML IdP** and **SCIM**.

## Features

- Optional CloudSSO directory creation
- **SAML IdP configuration** on the directory (enterprise IdP federation)
- SAML SP outputs (ACS URL / entity ID / metadata) for IdP setup
- MFA / login preference / local password policy on the directory
- **SCIM** server credentials for automated user provisioning
- Users and groups with group membership attachments
- Access configurations (permission sets) with System / Inline policies
- Access assignments from users or groups to RD member accounts

## Production note

Prefer federated IdP + SCIM over local CloudSSO passwords. Apply from the organization master (or CloudSSO delegated administrator) account.

For **single-account** SAML (no Resource Directory), use [`ram`](../ram) `saml_providers` instead.

SAML IdP nested settings are applied when `create_directory = true` (or after importing the directory into this resource).

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Users + group against an existing directory |
| `examples/complete` | Directory, permission sets, optional SAML metadata + SCIM |

## Usage

```hcl
module "cloudsso" {
  source = "../cloudsso"

  create_directory            = true
  directory_name              = "corp-sso"
  mfa_authentication_status   = "Enabled"
  scim_synchronization_status = "Enabled"

  saml_identity_provider_configuration = {
    encoded_metadata_document = var.idp_metadata_b64
    sso_status                = "Enabled"
  }

  scim_server_credentials = {
    primary = { status = "Enabled" }
  }

  access_configurations = {
    admin = {
      access_configuration_name = "AdministratorAccess"
      permission_policies = [{
        permission_policy_name = "AdministratorAccess"
        permission_policy_type = "System"
      }]
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
