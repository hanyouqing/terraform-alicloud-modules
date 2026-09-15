# Resource Group Module

Account-scoped Resource Manager Resource Groups for Alibaba Cloud.

## Features

- Create multiple resource groups via a map
- Optional explicit `resource_group_name` (defaults to map key)
- Standard ManagedBy / Module / Project / Environment tags

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single resource group |
| `examples/complete` | Multiple groups with tags |

## Usage

```hcl
module "resource_group" {
  source = "../resource-group"

  resource_groups = {
    app = {
      display_name        = "Application"
      resource_group_name = "rg-app"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
