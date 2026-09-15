# Redis Basic Example

Creates a PostPaid Redis instance in a private vSwitch with password auth and SSL enabled.

## Usage

```bash
terraform init
terraform plan \
  -var="vswitch_id=vsw-xxxxx" \
  -var="password=ChangeMe123!"
terraform apply \
  -var="vswitch_id=vsw-xxxxx" \
  -var="password=ChangeMe123!"
```
