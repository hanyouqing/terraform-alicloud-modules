# WAF Complete Example

Multiple WAFv3 domains (HTTP + HTTPS) on an existing paid instance.

## Usage

```bash
terraform init
terraform apply \
  -var='instance_id=waf_v3prepaid_xxx' \
  -var='www_domain=www.example.com' \
  -var='api_domain=api.example.com' \
  -var='backends=["1.2.3.4"]' \
  -var='cert_id=123456-cn-hangzhou'
```
