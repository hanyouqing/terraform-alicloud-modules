# Security Group Complete Example

Security group with HTTPS and restricted SSH ingress, plus default allow-all egress.

## Usage

```bash
terraform init
terraform apply -var='vpc_id=vpc-xxxxxxxx'
```

Lock down egress:

```bash
terraform apply \
  -var='vpc_id=vpc-xxxxxxxx' \
  -var='allow_all_egress=false' \
  -var='egress_rules={https={ip_protocol="tcp",port_range="443/443",cidr_ip="0.0.0.0/0",description="HTTPS out"}}'
```
