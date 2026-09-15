# CMS Basic Example

Contact group plus one ECS CPUUtilization alarm.

## Usage

```bash
terraform init
terraform plan \
  -var='instance_id=i-xxxxx' \
  -var='existing_contact_names=["ops-user"]'
```
