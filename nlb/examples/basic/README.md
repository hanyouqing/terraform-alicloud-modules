# NLB Basic Example

Intranet NLB with one TCP listener and a health-checked server group.

## Usage

```bash
terraform init
terraform plan \
  -var='vpc_id=vpc-xxx' \
  -var='zone_mappings=[{zone_id="cn-hangzhou-i",vswitch_id="vsw-aaa"},{zone_id="cn-hangzhou-j",vswitch_id="vsw-bbb"}]'
```
