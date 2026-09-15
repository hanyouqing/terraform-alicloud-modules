# KMS Module

Enterprise Key Management Service module for Alibaba Cloud CMKs, optional aliases, and optional secrets.

## Features

- `alicloud_kms_key` with `pending_window_in_days`, optional rotation, `protection_level` default `SOFTWARE`
- Optional `alicloud_kms_alias`
- Optional `alicloud_kms_secret` map (secret values sensitive; only IDs outputted)
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single CMK with deletion window |
| `examples/complete` | CMK + alias + secrets map with rotation |

## Usage

```hcl
module "kms" {
  source = "../kms"

  description            = "app CMK"
  pending_window_in_days = 30
  protection_level       = "SOFTWARE"
  automatic_rotation     = "Enabled"
  rotation_interval      = "90d"

  create_alias = true
  alias_name   = "alias/app-cmk"

  secrets = {
    db-password = {
      secret_data = var.db_password
      description = "RDS master password"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Security notes

- Secret values are marked sensitive and are never returned as outputs
- Prefer aliases over raw key IDs in application configuration

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
