# DNS Basic Example

Adds a public A record to an existing Alidns domain.

## Usage

```bash
terraform init
terraform plan \
  -var='domain_name=example.com' \
  -var='record_value=1.2.3.4'
```
