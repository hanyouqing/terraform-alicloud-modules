# ACK Basic Example

Managed ACK cluster with Flannel networking and a fixed-size encrypted node pool. Public API SLB is disabled.

## Usage

```bash
terraform init
terraform apply \
  -var='worker_vswitch_ids=["vsw-xxxxxxxx"]' \
  -var='key_name=my-keypair'
```
