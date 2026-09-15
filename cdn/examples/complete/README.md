# CDN Complete Example

Multiple CDN domains (web + download) with optional IP allow-list config.

## Usage

```bash
terraform init
terraform apply \
  -var='web_domain_name=cdn.example.com' \
  -var='download_domain_name=dl.example.com' \
  -var='origin_domain=origin.example.com' \
  -var='oss_origin=mybucket.oss-cn-hangzhou.aliyuncs.com'
```
