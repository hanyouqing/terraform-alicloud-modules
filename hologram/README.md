# Hologram Module

Enterprise-grade Alibaba Cloud Hologres (实时数仓) instances.

## Features

- Create multiple instances via `for_each` (`alicloud_hologram_instance`)
- Required per instance: `instance_name` (defaults to map key), `instance_type`, `payment_type`, `zone_id`
- Optional `endpoints` block for VPC networking; prefer `enable_ssl=true` in production
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal PostPaid instance |
| `examples/complete` | SSL enabled + VPC endpoints |

## Usage

```hcl
module "hologram" {
  source = "../hologram"

  instances = {
    warehouse = {
      instance_type = "Standard"
      payment_type  = "PostPaid"
      zone_id       = "cn-hangzhou-h"
      cpu           = 8
      enable_ssl    = true
      endpoints = [{
        type       = "VPCSingleTunnel"
        vpc_id     = "vpc-xxxxx"
        vswitch_id = "vsw-xxxxx"
      }]
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
| [alicloud_hologram_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/hologram_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances | Map of Hologres instances | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | Instance IDs |
| instance_names | Instance names |
| status | Instance status |
| endpoints | Endpoint blocks when available |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
