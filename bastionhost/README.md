# Bastionhost Module

Creates and configures Alibaba Cloud Bastionhost (堡垒机) using `alicloud_bastionhost_instance` (current name for provider `~> 1.292`; formerly `alicloud_yundun_bastionhost_instance`).

## Features

- Optional instance create (`create_instance`) or attach to existing `instance_id`
- License / plan / storage / bandwidth variables for paid SKUs
- Optional maps: users, user groups, hosts, host accounts, attachments
- Empty maps supported for instance-only or skip-paid workflows
- Tag merge: ManagedBy / Module / Project / Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Instance-only (`users`/`hosts` empty) |
| `examples/complete` | Instance + users/groups/hosts/accounts/attachments |

## Usage

```hcl
module "bastionhost" {
  source = "../bastionhost"

  create_instance    = true
  description        = "prod-bastion"
  license_code       = "bhah_ent_50_asset"
  plan_code          = "cloudbastion"
  storage            = "5"
  bandwidth          = "5"
  period             = 1
  vswitch_id         = module.vpc.private_vswitch_ids["private-a"]
  security_group_ids = [module.sg.security_group_id]

  users = {}
  hosts = {}

  project     = "my-project"
  environment = "production"
}
```

Skip paid create:

```hcl
module "bastionhost" {
  source = "../bastionhost"

  create_instance = false
  instance_id     = "bastionhost-cn-xxxxx"
  users = {
    alice = {
      password = "ChangeMe!123"
      source   = "Local"
    }
  }
}
```

## Notes

- Destroying the Terraform resource does **not** cancel the subscription instance.
- Prefer private access; keep `enable_public_access = false` unless required.

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
