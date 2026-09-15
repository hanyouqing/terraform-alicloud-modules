# ActionTrail Module

Enterprise [ActionTrail](https://www.alibabacloud.com/help/actiontrail) (操作审计) trails for Alibaba Cloud.

## Features

- `alicloud_actiontrail_trail` via `for_each` (`trails` map)
- OSS and/or SLS delivery destinations
- Optional organization (multi-account) trails for Landing Zone audit patterns
- Prefer **OSS delivery** into a dedicated log/security account bucket for LZ

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single-account trail delivering to an existing OSS bucket |
| `examples/complete` | Multiple trails (OSS + optional SLS / organization trail flags) |

## Usage

```hcl
module "actiontrail" {
  source = "../actiontrail"

  trails = {
    audit-oss = {
      trail_name         = "audit-oss"
      oss_bucket_name    = "my-audit-trail-bucket"
      oss_write_role_arn = "acs:ram::123456789012****:role/aliyunserviceroleforactiontrail"
      event_rw           = "All"
      status             = "Enable"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

### Landing Zone

Create an organization trail (`is_organization_trail = true`) from the management account, delivering to OSS in the log/security account. Ensure the ActionTrail service-linked role (or custom write role) can write to that bucket.

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- Pre-created OSS bucket (and optional SLS project) with appropriate write role

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
