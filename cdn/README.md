# CDN Module

Enterprise Alibaba Cloud CDN accelerated domains with optional function configs.

## Features

- `alicloud_cdn_domain_new` (`for_each`) with sources (type / content / port / priority / weight)
- Scope: `domestic` / `overseas` / `global`
- Optional `alicloud_cdn_domain_config` per domain via nested `configs` map
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | One web CDN domain with IP origin |
| `examples/complete` | Multi-domain, overseas scope, domain configs |

## Usage

```hcl
module "cdn" {
  source = "../cdn"

  domains = {
    www = {
      domain_name = "cdn.example.com"
      cdn_type    = "web"
      scope       = "domestic"
      sources = [
        {
          type     = "domain"
          content  = "origin.example.com"
          port     = 80
          priority = 20
          weight   = 10
        }
      ]
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- ICP filing may be required for `domestic` / `global` scope

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
