# SWAS Complete Example

Multiple Simple Application Server instances with firewall rules.

## Usage

```bash
terraform apply \
  -var='instances={web={image_id="img-xxx",plan_id="plan-xxx",period=1,data_disk_size=20},api={image_id="img-xxx",plan_id="plan-xxx",period=1}}' \
  -var='firewall_rules={web443={instance_key="web",rule_protocol="Tcp",port="443/443"},api22={instance_key="api",rule_protocol="Tcp",port="22/22"}}'
```
