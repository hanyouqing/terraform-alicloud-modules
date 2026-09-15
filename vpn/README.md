# VPN Module

Site-to-site IPsec VPN for Alibaba Cloud: VPN gateway, customer gateways, and connections.

## Features

- `alicloud_vpn_gateway` with vpc_id, optional vswitch_id, bandwidth, enable_ipsec
- `alicloud_vpn_customer_gateway` map
- `alicloud_vpn_connection` with IKE/IPsec configs (PSK sensitive)
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | VPN gateway + one customer gateway + one connection |
| `examples/complete` | Dual customer sites with tuned IKE/IPsec |

## Usage

```hcl
module "vpn" {
  source = "../vpn"

  vpn_gateway_name = "hq-vpn"
  vpc_id           = var.vpc_id
  vswitch_id       = var.vswitch_id
  bandwidth        = 10
  enable_ipsec     = true

  customer_gateways = {
    hq = {
      ip_address = "203.0.113.10"
    }
  }

  connections = {
    hq = {
      customer_gateway_key = "hq"
      local_subnet         = ["10.0.0.0/16"]
      remote_subnet        = ["192.168.0.0/16"]
      ike_config = {
        psk         = var.vpn_psk
        ike_version = "ikev2"
        ike_enc_alg = "aes256"
      }
      ipsec_config = {
        ipsec_enc_alg = "aes256"
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

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
