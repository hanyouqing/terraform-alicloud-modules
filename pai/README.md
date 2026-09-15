# PAI Module

Enterprise-grade Alibaba Cloud PAI (Platform for AI) workspace for custom model training and serving.

> **DashScope / Bailian (通义) LLM API keys** are provisioned in the console (out-of-band). This module manages PAI **infrastructure** for custom datasets, models, and online services — not managed LLM API credentials.

## Features

- Required workspace: `alicloud_pai_workspace_workspace` (`workspace_name`, `description`, `env_types`)
- Optional datasets via `for_each` (`alicloud_pai_workspace_dataset`)
- Optional models via `for_each` (`alicloud_pai_workspace_model`)
- Optional online services via `for_each` (`alicloud_pai_service`) with flexible `service_config` string/JSON
- Standard tagging on taggable resources (`pai_service`): ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal workspace |
| `examples/complete` | Workspace + dataset + model + service stub |

## Usage

```hcl
module "pai" {
  source = "../pai"

  workspace_name = "ml-workspace"
  description    = "Custom training and serving"
  env_types      = ["prod"]

  datasets = {
    training = {
      data_source_type = "OSS"
      property         = "DIRECTORY"
      uri              = "oss://my-bucket/datasets/train/"
    }
  }

  models = {
    custom-llm = {
      model_type = "Checkpoint"
      task       = "text-generation"
    }
  }

  services = {
    predictor = {
      service_config = jsonencode({
        metadata = { name = "predictor", instance = 1 }
      })
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
| [alicloud_pai_workspace_workspace.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pai_workspace_workspace) | resource |
| [alicloud_pai_workspace_dataset.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pai_workspace_dataset) | resource |
| [alicloud_pai_workspace_model.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pai_workspace_model) | resource |
| [alicloud_pai_service.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/pai_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace_name | PAI workspace name | `string` | n/a | yes |
| description | PAI workspace description | `string` | n/a | yes |
| env_types | Environment types | `set(string)` | n/a | yes |
| display_name | Display name | `string` | `null` | no |
| resource_group_id | Resource group ID | `string` | `null` | no |
| datasets | Optional datasets map | `map(object(...))` | `{}` | no |
| models | Optional models map | `map(object(...))` | `{}` | no |
| services | Optional services map | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | Workspace ID |
| workspace_name | Workspace name |
| workspace_status | Workspace status |
| dataset_ids | Dataset IDs |
| model_ids | Model IDs |
| service_ids | Service IDs |
| zzz_reminders | Operational reminders (incl. DashScope out-of-band) |
<!-- END_TF_DOCS -->
