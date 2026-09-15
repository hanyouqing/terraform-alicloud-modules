# ALB Complete Example

Multi-AZ Standard ALB with health-checked backends and optional HTTPS listener.

## Usage

```bash
terraform init
terraform apply \
  -var='vpc_id=vpc-xxx' \
  -var='zone_mappings=[{zone_id="cn-hangzhou-i",vswitch_id="vsw-aaa"},{zone_id="cn-hangzhou-j",vswitch_id="vsw-bbb"}]' \
  -var='certificate_id=cert-xxx'
```
