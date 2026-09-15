# NLB Complete Example

Multi-AZ NLB with health-checked backends and optional TCPSSL listener.

## Usage

```bash
terraform init
terraform apply \
  -var='vpc_id=vpc-xxx' \
  -var='zone_mappings=[{zone_id="cn-hangzhou-i",vswitch_id="vsw-aaa"},{zone_id="cn-hangzhou-j",vswitch_id="vsw-bbb"}]' \
  -var='certificate_ids=["cert-xxx"]'
```
