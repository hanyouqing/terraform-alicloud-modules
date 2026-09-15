# Security Group Module

Creates an Alibaba Cloud security group with keyed ingress/egress rule maps.

## Features

- Locked-down ingress by default (empty `ingress_rules`)
- Optional allow-all egress (`allow_all_egress=true` by default for usability)
- Rules support `cidr_ip`, `source_security_group_id`, `ipv6_cidr_ip`, or `prefix_list_id`
- Production tagging pattern

## Security defaults

| Direction | Default | Notes |
|-----------|---------|-------|
| Ingress | No rules | Explicitly open only what you need |
| Egress | Allow all (`0.0.0.0/0`, all protocols) | Set `allow_all_egress=false` for locked-down outbound |

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | SG with no ingress, default allow-all egress |
| `examples/complete` | HTTPS/SSH ingress CIDRs plus custom egress |

## Usage

```hcl
module "sg" {
  source = "../security-group"

  security_group_name = "app-sg"
  vpc_id              = module.vpc.vpc_id

  ingress_rules = {
    https = {
      ip_protocol = "tcp"
      port_range  = "443/443"
      cidr_ip     = "0.0.0.0/0"
      description = "HTTPS"
    }
  }

  allow_all_egress = true

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
