# WAF Module

Enterprise Web Application Firewall v3 (WAFv3) domain onboarding for Alibaba Cloud.

## Features

- Optional paid `alicloud_wafv3_instance` via `create_instance` (default `false`)
- `alicloud_wafv3_domain` (`for_each`) with listen ports and redirect backends
- Prefer supplying existing `instance_id` for examples/CI (instance creation is paid)
- Defense templates/rules are intentionally omitted (complex / product-edition specific)
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Manage one domain on an existing WAFv3 instance |
| `examples/complete` | Multi-domain HTTP/HTTPS with timeouts and headers |

## Usage

```hcl
module "waf" {
  source = "../waf"

  create_instance = false
  instance_id     = var.waf_instance_id

  domains = {
    www = {
      domain = "www.example.com"
      listen = {
        http_ports  = [80]
        https_ports = [443]
        cert_id     = var.cert_id
      }
      redirect = {
        backends    = ["1.2.3.4"]
        loadbalance = "iphash"
      }
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- An existing WAFv3 instance (recommended) or acceptance of paid instance creation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
