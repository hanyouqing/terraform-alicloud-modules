# RDS Module

Enterprise-grade Alibaba Cloud ApsaraDB RDS for MySQL and PostgreSQL with private networking, backups, and optional accounts.

## Features

- Create multiple instances via `for_each` (`alicloud_db_instance`)
- Engines: MySQL / PostgreSQL
- Private `vswitch_id`; `security_ips` default to VPC CIDR via `default_security_ips`
- SSL optional (`ssl_action`, default `Open`)
- Optional disk encryption (`encryption_key`) and TDE (`tde_status`)
- Backup policy per instance (`alicloud_db_backup_policy`)
- Optional accounts (`alicloud_rds_account`, successor to deprecated `alicloud_db_account`) with sensitive passwords
- Multi-AZ via `zone_id` + `zone_id_slave_a`
- `instance_charge_type` defaults to `Postpaid`
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single Postpaid MySQL instance |
| `examples/complete` | Multi-AZ with account and custom backup |

## Usage

```hcl
module "rds" {
  source = "../rds"

  default_security_ips = ["10.0.0.0/16"]

  instances = {
    primary = {
      engine           = "MySQL"
      engine_version   = "8.0"
      instance_type    = "mysql.n2.medium.1"
      instance_storage = 20
      instance_name    = "app-mysql"
      vswitch_id       = "vsw-xxxxx"
      ssl_action       = "Open"
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
| alicloud_db_instance.this | resource |
| alicloud_db_backup_policy.this | resource |
| alicloud_rds_account.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances | Map of RDS instances | `map(object(...))` | `{}` | no |
| default_security_ips | Default whitelist CIDRs | `list(string)` | `["10.0.0.0/8"]` | no |
| accounts | Optional DB accounts (sensitive) | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | Instance IDs |
| connection_strings | Connection strings |
| ports | Ports |
| account_ids | Account IDs |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
