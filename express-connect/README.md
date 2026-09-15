# Express Connect Module (高速通道 / 专线)

Enterprise Express Connect module for Alibaba Cloud dedicated lines, including domestic and overseas (跨境/海外) access points. Terraform typically manages **Virtual Border Routers (VBRs)** and optional router interfaces; physical ports are frequently ordered offline.

## Features

- Optional `alicloud_express_connect_physical_connection` (`create_physical_connection=false` + `physical_connection_id` for console/carrier-ordered lines)
- `alicloud_express_connect_virtual_border_router` via `for_each` (VLAN, peering IPs, optional IPv6/BFD)
- Optional `alicloud_express_connect_router_interface` for legacy VBR↔VPC attachment
- Production tagging on VBR and router interfaces

## Physical line ordering (含海外专线接入)

| Step | Owner | Notes |
|------|-------|-------|
| Choose access point / LoA | Network + carrier | Mainland: CT/CU/CM/CO; overseas: Equinix / Other |
| Order physical port | Console or sales | Cross-border circuits often cannot be fully automated |
| Enable connection | Console / Terraform | `status=Enabled` requires `period` |
| Create VBR(s) | **This module** | VLAN + local/peer gateway IPs |
| Attach to CEN / VPC | `cen` module or router interface | Prefer CEN for multi-region |

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Existing physical connection + single VBR |
| `examples/complete` | Optional physical create, multiple VBRs, optional router interface |

## Usage

```hcl
module "express_connect" {
  source = "../express-connect"

  create_physical_connection = false
  physical_connection_id     = "pc-xxxxxxxx"

  virtual_border_routers = {
    vbr-hq = {
      vlan_id             = 1001
      local_gateway_ip    = "10.0.0.1"
      peer_gateway_ip     = "10.0.0.2"
      peering_subnet_mask = "255.255.255.252"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

Pair with a CEN module to advertise VBR routes across regions and VPCs.

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
