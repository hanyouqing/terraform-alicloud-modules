# Landing Zone Module

Opinionated multi-account Landing Zone blueprint for Alibaba Cloud Resource Directory.

> **Run on the management/master account only.** This module is a self-contained composition (resources are inline — not nested `module` blocks to sibling directories) so a single version pin owns the full RD skeleton.

## Features

- Optional `alicloud_resource_manager_resource_directory`
- Default OU/folder layout when `enable_default_structure=true`:
  - Core
  - Infrastructure
  - Security
  - Workloads (+ optional children Production / NonProduction)
- Optional member accounts map (`display_name`, `folder_key`, `payer_account_id`)
- Optional baseline control policies:
  - DenyLeaveOrganization
  - Protect ResourceDirectoryAccountAccessRole
  - Attached to Core / Security / Workloads by default
- Optional delegated administrators for trusted services
- `zzz_reminders` output with LZ next steps

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Default folder structure only (no member accounts) |
| `examples/complete` | Folders + placeholder member accounts + baseline policies |

## Usage

```hcl
module "landing_zone" {
  source = "../landing-zone"

  create_resource_directory = false # set true only when enabling RD for the first time
  enable_default_structure  = true
  enable_workload_children  = true

  create_baseline_policies       = true
  enable_deny_leave_organization = true
  enable_protect_rd_access_role  = true

  project     = "enterprise"
  environment = "management"
}
```

## Security defaults

- Baseline SCPs are off by default (`create_baseline_policies=false`) to avoid surprising org-wide denies
- Prefer creating members with `payer_account_id` set to a dedicated billing account
- Pair day-2 RD operations with a dedicated `resource-directory` module when you outgrow this blueprint

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- Credentials for the **management/master** account

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
