# WAF Basic Example

Onboards one domain to an existing WAFv3 instance (no instance creation).

## Usage

```bash
terraform init
terraform plan \
  -var='instance_id=waf_v3prepaid_xxx' \
  -var='domain=www.example.com' \
  -var='backends=["1.2.3.4"]'
```
