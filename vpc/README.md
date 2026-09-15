# VPC Module

Enterprise VPC foundation for Alibaba Cloud with public/private vswitches, optional Enhanced NAT Gateway (EIP + SNAT), optional custom route tables, and optional VPC flow logs to SLS.

## Features

- `alicloud_vpc` with primary and optional secondary CIDR blocks
- Public and private vswitches via maps (`zone_id`, `cidr_block`, `vswitch_name`)
- Optional Enhanced NAT Gateway + EIP + association + SNAT for private vswitches
- Optional custom route tables (public uses system table by default; private can route `0.0.0.0/0` to NAT)
- Optional VPC flow logs to an existing SLS project/logstore
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | VPC + one public vswitch |
| `examples/complete` | Public/private vswitches, NAT/SNAT, optional route tables and flow logs |

## Usage

```hcl
module "vpc" {
  source = "../vpc"

  vpc_name   = "app-vpc"
  cidr_block = "10.0.0.0/16"

  public_vswitches = {
    public-a = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "public-a"
    }
  }

  private_vswitches = {
    private-a = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.11.0/24"
      vswitch_name = "private-a"
    }
  }

  create_nat_gateway         = true
  create_private_route_tables = true

  project     = "my-project"
  environment = "production"
}
```

## Security defaults

- No security group rules are created here; pair with the `security-group` module
- NAT/SNAT is off by default to avoid unexpected cost
- Flow logs are off by default and require an existing SLS destination

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
