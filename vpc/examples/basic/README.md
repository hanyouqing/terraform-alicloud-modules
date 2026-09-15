# VPC Basic Example

Minimal VPC with a single public vswitch. No NAT Gateway or flow logs.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Override region/zone as needed:

```bash
terraform apply -var='region=cn-hangzhou' -var='zone_id=cn-hangzhou-i'
```
