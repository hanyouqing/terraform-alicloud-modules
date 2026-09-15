# Resource Directory Module

Enterprise Resource Manager module for Alibaba Cloud organization / multi-account Resource Directory.

## Features

- Optional Resource Directory creation (once per master account)
- Folders with one nesting level via `parent_folder_key`, or `parent_folder_id` for existing / deeper parents
- Member accounts with folder placement and optional payer / name prefix
- Custom Control Policies and attachments (folder or account)
- Delegated administrators by account key + service principal

## Nesting note

`folders` supports:

1. **Root** — `parent_folder_key` and `parent_folder_id` both null
2. **One child level** — `parent_folder_key` references a root key in the same map
3. **External / deeper** — pass `parent_folder_id` (e.g. from `folder_ids` after a prior apply)

## Production note

Apply from the **master account** only. Creating member accounts is effectively irreversible in many cases. Enable the Control Policy feature in the console if policy attachments fail.

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Folders only under an existing directory |
| `examples/complete` | Directory, nested folders, account, policy, attachment, delegated admin |

## Usage

```hcl
module "resource_directory" {
  source = "../resource-directory"

  create_resource_directory = false

  folders = {
    production = {
      folder_name = "production"
    }
    prod-app = {
      folder_name       = "app"
      parent_folder_key = "production"
    }
  }

  accounts = {
    prod-workload = {
      display_name = "prod-workload"
      folder_key   = "prod-app"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- Credentials for the Resource Directory **master** account

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
