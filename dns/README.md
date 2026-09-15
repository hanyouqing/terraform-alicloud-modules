# DNS Module

Enterprise public DNS (Alidns) with optional PrivateZone for Alibaba Cloud.

## Features

- `alicloud_alidns_domain` (`for_each`) and/or attach records to an existing `domain_name`
- `alicloud_alidns_record` (`for_each`: rr, type, value, ttl, line, priority)
- Optional `alicloud_pvtz_zone`, `alicloud_pvtz_zone_record`, `alicloud_pvtz_zone_attachment` (`vpc_ids`)
- Prefers `alicloud_alidns_*` over deprecated `alicloud_dns_*`
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Records against an existing public domain |
| `examples/complete` | Create domain + records + PrivateZone + VPC attachment |

## Usage

```hcl
module "dns" {
  source = "../dns"

  domain_name = "example.com"

  records = {
    www = {
      rr    = "www"
      type  = "A"
      value = "1.2.3.4"
      ttl   = 600
    }
  }

  private_zones = {
    internal = {
      zone_name = "internal.example.com"
      vpc_ids   = [var.vpc_id]
    }
  }

  private_zone_records = {
    api = {
      zone_key = "internal"
      rr       = "api"
      type     = "A"
      value    = "10.0.1.10"
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
<!-- END_TF_DOCS -->
