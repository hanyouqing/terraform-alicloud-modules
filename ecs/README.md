# ECS Module

Creates one or more Alibaba Cloud ECS instances from a keyed map.

## Features

- `for_each` map of instances (`image_id`, `instance_type`, `vswitch_id`, `security_groups`)
- System disk defaults: `cloud_essd`, encrypted
- Optional encrypted data disks
- `key_name` or sensitive `password`
- Optional `user_data` (ignored after create)
- `internet_max_bandwidth_out` default `0` (no public IP)
- Optional `deletion_protection`
- Tag merge: module defaults + module `tags` + per-instance `tags`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single private instance |
| `examples/complete` | Multi-instance with data disks and deletion protection |

## Usage

```hcl
module "ecs" {
  source = "../ecs"

  instances = {
    app-1 = {
      image_id        = "aliyun_3_x64_20G_alibase_*.vhd"
      instance_type   = "ecs.g7.large"
      vswitch_id      = module.vpc.private_vswitch_ids["private-a"]
      security_groups = [module.sg.security_group_id]
      key_name        = "my-keypair"
      system_disk = {
        category  = "cloud_essd"
        size      = 40
        encrypted = true
      }
      deletion_protection = true
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Security defaults

- No public IP unless `internet_max_bandwidth_out` > 0
- Encrypted system and data disks by default
- Requires `key_name` or `password` per instance

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
