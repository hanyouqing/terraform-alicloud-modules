# VPN Complete Example

Dual-site VPN with HQ and DR customer gateways and tuned IKE/IPsec settings.

## Usage

```bash
terraform init
terraform apply \
  -var='vpc_id=vpc-xxx' \
  -var='hq_customer_gateway_ip=203.0.113.10' \
  -var='dr_customer_gateway_ip=203.0.113.20' \
  -var='hq_psk=hq-strong-psk' \
  -var='dr_psk=dr-strong-psk'
```
