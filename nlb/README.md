# NLB Module

Enterprise Network Load Balancer (NLB) for Alibaba Cloud L4 (TCP/UDP/TCPSSL) workloads.

## Features

- `alicloud_nlb_load_balancer` with VPC, address type, and multi-AZ `zone_mappings`
- `alicloud_nlb_server_group` with health checks
- Backend attachments via `alicloud_nlb_server_group_server_attachment`
- `alicloud_nlb_listener` for TCP / UDP / TCPSSL
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Intranet NLB + TCP listener + empty server group |
| `examples/complete` | Multi-AZ NLB, backends, TCP + optional TCPSSL |

## Usage

```hcl
module "nlb" {
  source = "../nlb"

  load_balancer_name = "app-nlb"
  vpc_id             = var.vpc_id
  address_type       = "Intranet"

  zone_mappings = [
    { zone_id = "cn-hangzhou-i", vswitch_id = var.vswitch_a },
    { zone_id = "cn-hangzhou-j", vswitch_id = var.vswitch_b },
  ]

  server_groups = {
    app = {
      protocol = "TCP"
      health_check = {
        health_check_enabled = true
        health_check_type    = "TCP"
      }
    }
  }

  listeners = {
    tcp = {
      listener_protocol = "TCP"
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
- At least two vSwitches in different NLB zones

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
