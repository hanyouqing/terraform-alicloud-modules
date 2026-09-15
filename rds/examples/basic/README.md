# RDS Basic Example

Creates a Postpaid MySQL RDS instance in a private vSwitch with VPC CIDR whitelist and SSL enabled.

## Usage

```bash
terraform init
terraform plan \
  -var="vswitch_id=vsw-xxxxx" \
  -var="vpc_cidr=10.0.0.0/16"
terraform apply \
  -var="vswitch_id=vsw-xxxxx" \
  -var="vpc_cidr=10.0.0.0/16"
```
