# ACK Complete Example

ACK Pro cluster with Terway networking, RRSA, CSI addons, and caller-supplied node pools (static and/or autoscaling). Public API remains disabled.

## Usage

```bash
terraform init
terraform apply \
  -var='worker_vswitch_ids=["vsw-a","vsw-b"]' \
  -var='pod_vswitch_ids=["vsw-pod-a","vsw-pod-b"]' \
  -var='node_pools={default={instance_types=["ecs.g7.xlarge"],vswitch_ids=["vsw-a"],desired_size=2,key_name="my-keypair"},autoscale={instance_types=["ecs.g7.xlarge"],vswitch_ids=["vsw-a","vsw-b"],key_name="my-keypair",scaling_config={min_size=1,max_size=6}}}'
```
