# CEN Module

Creates an Alibaba Cloud Cloud Enterprise Network (云企业网) hub for private connectivity across VPCs / VBRs / regions.

## Features

- `alicloud_cen_instance`
- Classic `alicloud_cen_instance_attachment` map (`VPC` / `VBR` / `CCN`)
- Optional bandwidth package + attachment + inter-region `bandwidth_limits`
- Optional transit router + VPC attachments (light TR path)
- Tag merge: ManagedBy / Module / Project / Environment

## Cross-region / overseas connectivity

For **海外** or Express Connect (高速通道) physical / VBR handoff into CEN, pair this module with an **express-connect** module that provisions the physical connection / VBR, then attach the VBR here (`child_instance_type = "VBR"`).

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | CEN instance + VPC attachment |
| `examples/complete` | Bandwidth package, limits, optional TR |

## Usage

```hcl
module "cen" {
  source = "../cen"

  cen_instance_name = "demo-cen"

  attachments = {
    hangzhou-vpc = {
      child_instance_id        = module.vpc.vpc_id
      child_instance_type      = "VPC"
      child_instance_region_id = "cn-hangzhou"
    }
  }

  create_bandwidth_package = true
  geographic_region_a_id   = "China"
  geographic_region_b_id   = "China"
  bandwidth                = 5

  bandwidth_limits = {
    hz-sh = {
      region_ids      = ["cn-hangzhou", "cn-shanghai"]
      bandwidth_limit = 2
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
