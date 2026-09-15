# VPN Basic Example

Site-to-site VPN with one customer gateway and one IPsec connection.

## Usage

```bash
terraform init
terraform apply \
  -var='vpc_id=vpc-xxx' \
  -var='customer_gateway_ip=203.0.113.10' \
  -var='psk=change-me-strong-psk'
```
