# Realtime Compute Module

Enterprise-grade Alibaba Cloud Realtime Compute Flink (流计算 / VVP) instance and optional deployments.

## Features

- Required VVP fields: `payment_type`, `vpc_id`, `vswitch_ids`, `vvp_instance_name`, `zone_id`
- Dynamic `resource_spec` and `storage` (OSS bucket required by provider on create)
- Optional deployments map (`alicloud_realtime_compute_deployment`); each deployment requires `artifact` (kind + jar/python/sql)
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal VPC-bound VVP instance |
| `examples/complete` | VPC-bound instance with `resource_spec` + optional deployment stub |

## Usage

```hcl
module "realtime_compute" {
  source = "../realtime-compute"

  vvp_instance_name = "flink-prod"
  payment_type      = "PayAsYouGo"
  vpc_id            = "vpc-xxxxx"
  vswitch_ids       = ["vsw-xxxxx"]
  zone_id           = "cn-hangzhou-i"
  storage = {
    oss_bucket = "my-flink-state"
  }
  resource_spec = {
    cpu       = 8
    memory_gb = 32
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
| [alicloud_realtime_compute_vvp_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/realtime_compute_vvp_instance) | resource |
| [alicloud_realtime_compute_deployment.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/realtime_compute_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vvp_instance | Create VVP instance | `bool` | `true` | no |
| vvp_instance_name | VVP instance name | `string` | `null` | no |
| payment_type | Payment type | `string` | `"PayAsYouGo"` | no |
| vpc_id | VPC ID | `string` | `null` | no |
| vswitch_ids | vSwitch IDs | `list(string)` | `[]` | no |
| zone_id | Zone ID | `string` | `null` | no |
| resource_spec | Optional CU spec | `object(...)` | `null` | no |
| storage | OSS storage (`oss_bucket`) | `object(...)` | `null` | no |
| deployments | Optional deployments map | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vvp_instance_id | VVP instance ID |
| vvp_resource_id | Resource ID for deployments |
| deployment_ids | Deployment IDs |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
