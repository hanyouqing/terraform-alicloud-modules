# MaxCompute Module

Enterprise-grade Alibaba Cloud MaxCompute (大数据仓库 / ODPS) projects.

## Features

- Create multiple projects via `for_each` (`alicloud_maxcompute_project`)
- Optional `ip_white_list`, `security_properties`, and `properties` (incl. encryption / table lifecycle) dynamic blocks
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal project |
| `examples/complete` | Project with IP whitelist, security, and encryption properties |

## Usage

```hcl
module "maxcompute" {
  source = "../maxcompute"

  projects = {
    dw = {
      comment       = "enterprise data warehouse"
      default_quota = "os_PayAsYouGoQuota"
      ip_white_list = {
        vpc_ip_list = "10.0.0.0/8"
      }
      security_properties = {
        using_acl     = true
        using_policy  = true
        label_security = true
      }
      properties = {
        enable_decimal2 = true
        encryption = {
          enable    = true
          algorithm = "AES256"
        }
      }
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
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| alicloud | ~> 1.292 |

## Providers

| Name | Version |
|------|---------|
| alicloud | ~> 1.292 |

## Resources

| Name | Type |
|------|------|
| [alicloud_maxcompute_project.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/maxcompute_project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| projects | Map of MaxCompute projects | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| project_ids | Project IDs |
| project_names | Project names |
| status | Project status |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
