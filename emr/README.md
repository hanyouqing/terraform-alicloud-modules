# E-MapReduce Module (大数据)

Enterprise Alibaba Cloud EMR **v2** clusters (`alicloud_emrv2_cluster`) for Spark / Hive / data-lake workloads.

## Features

- Required: `applications`, `cluster_name`, `cluster_type`, `release_version`
- Structured `node_attributes` + `node_groups` (required for real clusters)
- Optional application configs and bootstrap scripts
- Tagging on the cluster resource
- `zzz_reminders` highlights cost risk and `security_mode`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | PayAsYouGo DATALAKE with MASTER + CORE |
| `examples/complete` | `deletion_protection=true`, encrypted disks, private networking |

## Usage

```hcl
module "emr" {
  source = "../emr"

  cluster_name    = "app-emr"
  cluster_type    = "DATALAKE"
  release_version = "EMR-5.10.0"
  payment_type    = "PayAsYouGo"
  applications    = ["SPARK", "HIVE", "HDFS", "YARN"]

  node_attributes = [{
    vpc_id            = "vpc-xxxxx"
    zone_id           = "cn-hangzhou-h"
    security_group_id = "sg-xxxxx"
    key_pair_name     = "my-keypair"
    ram_role          = "AliyunECSInstanceForEMRRole"
  }]

  node_groups = [
    {
      node_group_name = "master-group"
      node_group_type = "MASTER"
      node_count      = 1
      instance_types  = ["ecs.g7.xlarge"]
      vswitch_ids     = ["vsw-xxxxx"]
      payment_type    = "PayAsYouGo"
      system_disk = {
        category = "cloud_essd"
        size     = 80
      }
    },
    {
      node_group_name = "core-group"
      node_group_type = "CORE"
      node_count      = 2
      instance_types  = ["ecs.g7.xlarge"]
      vswitch_ids     = ["vsw-xxxxx"]
      payment_type    = "PayAsYouGo"
      system_disk = {
        category = "cloud_essd"
        size     = 80
      }
    }
  ]

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
| [alicloud_emrv2_cluster.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/emrv2_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_cluster | Whether to create an EMR v2 cluster | `bool` | `true` | no |
| applications | EMR applications | `set(string)` | `["SPARK", "HIVE", "HDFS", "YARN"]` | no |
| cluster_name | EMR cluster name | `string` | `null` | no |
| cluster_type | EMR cluster type | `string` | `"DATALAKE"` | no |
| release_version | EMR release version | `string` | `"EMR-5.10.0"` | no |
| payment_type | Cluster payment type | `string` | `"PayAsYouGo"` | no |
| deletion_protection | Enable deletion protection | `bool` | `false` | no |
| node_attributes | Node attributes list | `list(object(...))` | `[]` | no |
| node_groups | Node groups list | `list(object(...))` | `[]` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EMR v2 cluster ID |
| security_mode | Cluster security mode |
| payment_type | Cluster payment type |
| zzz_reminders | Cost and security reminders |
<!-- END_TF_DOCS -->
