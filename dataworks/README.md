# DataWorks Module (数据开发/治理)

Enterprise Alibaba Cloud **DataWorks** project for data development and governance.

## Features

- Create project (`alicloud_data_works_project`): `display_name`, `project_name`, `pai_task_enabled`
- Optional DW resource groups (`alicloud_data_works_dw_resource_group`)
- Optional project members (`alicloud_data_works_project_member`)
- Tagging on project and resource groups

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal project |
| `examples/complete` | Project + optional resource group + members |

## Usage

```hcl
module "dataworks" {
  source = "../dataworks"

  display_name     = "App Analytics"
  project_name     = "app_analytics"
  pai_task_enabled = false
  description      = "data development"

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
| [alicloud_data_works_project.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/data_works_project) | resource |
| [alicloud_data_works_dw_resource_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/data_works_dw_resource_group) | resource |
| [alicloud_data_works_project_member.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/data_works_project_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_project | Whether to create a DataWorks project | `bool` | `true` | no |
| display_name | Project display name | `string` | `null` | no |
| project_name | Project name | `string` | `null` | no |
| pai_task_enabled | Enable PAI tasks | `bool` | `false` | no |
| dw_resource_groups | Optional DW resource groups | `map(object(...))` | `{}` | no |
| project_members | Optional project members | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| project_id | DataWorks project ID |
| project_name | DataWorks project name |
| resource_group_ids | DW resource group IDs |
| member_ids | Project member resource IDs |
| zzz_reminders | Reminders for DataWorks |
<!-- END_TF_DOCS -->
