# ACK Module

Creates an Alibaba Cloud Container Service for Kubernetes (**ACK**) managed cluster with optional node pools.

Prefer managed ACK (`alicloud_cs_managed_kubernetes`) over dedicated `alicloud_cs_kubernetes`.

## Features

- Managed ACK cluster (`ack.pro.small` default)
- Control-plane vSwitches via `worker_vswitch_ids` (mapped to provider `vswitch_ids`)
- Flannel (`pod_cidr`) or Terway (`pod_vswitch_ids` + `terway-eniip` addon)
- `new_nat_gateway` default `false` (use the vpc module for NAT)
- Deletion protection on by default; public API SLB off by default
- Node pools via `for_each` with encrypted `cloud_essd` system disks and CloudMonitor
- Optional autoscaling via `scaling_config`
- Tag merge: ManagedBy / Module / Project / Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Flannel cluster with one static node pool |
| `examples/complete` | Terway Pro cluster, autoscaling pool, private API |

## Usage

```hcl
module "ack" {
  source = "../ack"

  cluster_name       = "demo-ack"
  worker_vswitch_ids = [module.vpc.private_vswitch_ids["private-a"]]
  network_plugin     = "flannel"
  pod_cidr           = "172.20.0.0/16"
  service_cidr       = "172.21.0.0/20"
  new_nat_gateway    = false
  deletion_protection = true
  slb_internet_enabled = false

  node_pools = {
    default = {
      instance_types = ["ecs.g7.xlarge"]
      vswitch_ids    = [module.vpc.private_vswitch_ids["private-a"]]
      desired_size   = 2
      key_name       = "my-keypair"
      system_disk_category  = "cloud_essd"
      system_disk_encrypted = true
      install_cloud_monitor = true
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Security defaults

- Private API preferred (`slb_internet_enabled = false`)
- CA material not persisted by default (`skip_set_certificate_authority = true`)
- Use data source `alicloud_cs_cluster_credential` for kubeconfig; treat as sensitive
- Encrypted node system disks; CloudMonitor enabled on pools

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
