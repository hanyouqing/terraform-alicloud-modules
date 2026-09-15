# ALB Module

Enterprise Application Load Balancer (ALB) for Alibaba Cloud. Prefer ALB over classic SLB for L7 workloads.

## Features

- `alicloud_alb_load_balancer` with VPC, address type (Internet/Intranet), and multi-AZ `zone_mappings`
- `alicloud_alb_server_group` with health checks and optional backends
- `alicloud_alb_listener` for HTTP/HTTPS (HTTPS requires `certificate_id`)
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Internet ALB + HTTP listener + empty server group |
| `examples/complete` | Multi-AZ ALB, health-checked server group, HTTP + HTTPS listeners |

## Usage

```hcl
module "alb" {
  source = "../alb"

  load_balancer_name = "app-alb"
  vpc_id             = var.vpc_id
  address_type       = "Internet"

  zone_mappings = [
    { zone_id = "cn-hangzhou-i", vswitch_id = var.vswitch_a },
    { zone_id = "cn-hangzhou-j", vswitch_id = var.vswitch_b },
  ]

  server_groups = {
    app = {
      protocol = "HTTP"
      health_check = {
        health_check_enabled  = true
        health_check_path     = "/healthz"
        health_check_protocol = "HTTP"
      }
    }
  }

  listeners = {
    http = {
      listener_protocol = "HTTP"
      listener_port     = 80
      server_group_key  = "app"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- At least two vSwitches in different zones

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
