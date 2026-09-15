# AnalyticDB Module (分析型数据库)

Enterprise-grade Alibaba Cloud AnalyticDB for MySQL **lake version** clusters for modern analytics / lakehouse workloads.

## Features

- Create multiple lake clusters via `for_each` (`alicloud_adb_db_cluster_lake_version`)
- Required per cluster: `db_cluster_version`, `payment_type`, `vpc_id`, `vswitch_id`, `zone_id`
- Production defaults: `disk_encryption=true`, `enable_ssl=true`, `security_ips` from VPC CIDR
- Optional `alicloud_adb_lake_account` for_each (password not marking whole map sensitive)
- Note: lake cluster resource does not support tags; tagging locals are retained for module consistency

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal PayAsYouGo / PostPaid lake cluster |
| `examples/complete` | Encrypted + SSL + VPC security_ips + optional account |

## Usage

```hcl
module "adb" {
  source = "../adb"

  default_security_ips = ["10.0.0.0/16"]

  clusters = {
    analytics = {
      db_cluster_version     = "5.0"
      payment_type           = "PayAsYouGo"
      vpc_id                 = "vpc-xxxxx"
      vswitch_id             = "vsw-xxxxx"
      zone_id                = "cn-hangzhou-h"
      db_cluster_description = "app-analytics"
      disk_encryption        = true
      enable_ssl             = true
      compute_resource       = "16ACU"
      storage_resource       = "0ACU"
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
| [alicloud_adb_db_cluster_lake_version.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/adb_db_cluster_lake_version) | resource |
| [alicloud_adb_lake_account.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/adb_lake_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| clusters | Map of AnalyticDB lake-version clusters | `map(object(...))` | `{}` | no |
| default_security_ips | Default security IP list (VPC CIDR) | `list(string)` | `["10.0.0.0/8"]` | no |
| accounts | Optional lake accounts | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_ids | AnalyticDB lake-version cluster IDs |
| connection_strings | Cluster connection strings |
| ports | Cluster ports |
| statuses | Cluster status |
| account_names | Lake account names |
| zzz_reminders | Important reminders for AnalyticDB lake clusters |
<!-- END_TF_DOCS -->
