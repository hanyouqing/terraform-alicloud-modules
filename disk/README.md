# Disk Module

Enterprise-grade Alibaba Cloud ECS disks (ESSD by default) with encryption, optional attachments, and snapshot policies.

## Features

- Create multiple disks via `for_each` (`alicloud_ecs_disk`)
- Default category `cloud_essd`, encrypted, performance level `PL1`
- Optional `alicloud_ecs_disk_attachment`
- Optional automatic snapshot policies and attachments
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single encrypted ESSD |
| `examples/complete` | Disks with attachments and snapshot policy |

## Usage

```hcl
module "disk" {
  source = "../disk"

  disks = {
    data = {
      disk_name         = "app-data"
      zone_id           = "cn-hangzhou-i"
      size              = 40
      category          = "cloud_essd"
      performance_level = "PL1"
      encrypted         = true
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
| alicloud_ecs_disk.this | resource |
| alicloud_ecs_disk_attachment.this | resource |
| alicloud_ecs_auto_snapshot_policy.this | resource |
| alicloud_ecs_auto_snapshot_policy_attachment.this | resource |
| alicloud_ecs_auto_snapshot_policy_attachment.external | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| disks | Map of ECS disks | `map(object(...))` | `{}` | no |
| attachments | Optional disk attachments | `map(object(...))` | `{}` | no |
| snapshot_policies | Optional snapshot policies | `map(object(...))` | `{}` | no |
| snapshot_policy_attachments | Attach policies to disks | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| disk_ids | Disk IDs |
| disk_names | Disk names |
| attachments | Attachment IDs |
| snapshot_policy_ids | Snapshot policy IDs |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
