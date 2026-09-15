# DNS Complete Example

Creates a public Alidns domain with records plus an optional PrivateZone attached to VPCs.

## Usage

```bash
terraform init
terraform apply \
  -var='domain_name=example.com' \
  -var='apex_value=1.2.3.4' \
  -var='vpc_ids=["vpc-xxx"]'
```
