# CDN Basic Example

One overseas web CDN domain with an IP origin.

## Usage

```bash
terraform init
terraform plan \
  -var='domain_name=cdn.example.com' \
  -var='origin_ip=1.2.3.4'
```
