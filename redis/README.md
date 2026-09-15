# Redis Module

Enterprise-grade Alibaba Cloud Tair/Redis (KVStore) instances with VPC networking, auth, SSL, and backups.

## Features

- Create multiple instances via `for_each` (`alicloud_kvstore_instance`)
- `instance_type` Redis (default) or Memcache
- Private `vswitch_id`, sensitive `password`
- `ssl_enable`, `vpc_auth_mode`, backup and maintain windows
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single PostPaid Redis instance |
| `examples/complete` | Multi-zone options with custom backup/maintain windows |

## Usage

```hcl
module "redis" {
  source = "../redis"

  default_security_ips = ["10.0.0.0/16"]

  instances = {
    cache = {
      db_instance_name = "app-redis"
      vswitch_id       = "vsw-xxxxx"
      instance_class   = "redis.master.small.default"
      engine_version   = "5.0"
      password         = var.redis_password
      ssl_enable       = "Enable"
      vpc_auth_mode    = "Open"
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
| alicloud_kvstore_instance.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances | Map of Redis/Tair instances (sensitive) | `map(object(...))` | `{}` | no |
| default_security_ips | Default whitelist CIDRs | `list(string)` | `["10.0.0.0/8"]` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | Instance IDs |
| connection_domains | Connection domains |
| ports | Ports |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
