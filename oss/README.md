# OSS Module

Enterprise-grade Alibaba Cloud Object Storage Service (OSS) buckets with encryption, versioning, force SSL, and private ACL defaults.

## Features

- Create multiple buckets via `for_each`
- Private ACL by default (`alicloud_oss_bucket_acl`)
- Versioning enabled by default (`alicloud_oss_bucket_versioning`)
- Server-side encryption AES256 or KMS (`alicloud_oss_bucket_server_side_encryption`)
- Force HTTPS via bucket policy (`acs:SecureTransport`)
- Public access block when enabled
- Optional lifecycle rules and access logging
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single private encrypted bucket |
| `examples/complete` | Multi-bucket with lifecycle, logging, and KMS options |

## Usage

```hcl
module "oss" {
  source = "../oss"

  buckets = {
    app = {
      name          = "my-app-bucket-prod"
      storage_class = "Standard"
      acl           = "private"
      versioning    = true
      sse_algorithm = "AES256"
      force_ssl     = true
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
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| alicloud | ~> 1.292 |

## Providers

| Name | Version |
|------|---------|
| alicloud | ~> 1.292 |

## Resources

| Name | Type |
|------|------|
| alicloud_oss_bucket.this | resource |
| alicloud_oss_bucket_acl.this | resource |
| alicloud_oss_bucket_versioning.this | resource |
| alicloud_oss_bucket_server_side_encryption.this | resource |
| alicloud_oss_bucket_policy.force_ssl | resource |
| alicloud_oss_bucket_public_access_block.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| buckets | Map of OSS buckets to create | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_names | Names of the OSS buckets |
| bucket_ids | IDs of the OSS buckets |
| extranet_endpoints | Public endpoints |
| intranet_endpoints | VPC endpoints |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
