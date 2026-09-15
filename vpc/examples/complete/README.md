# VPC Complete Example

Full topology: multi-AZ public/private vswitches, Enhanced NAT Gateway with EIP and SNAT, and private custom route tables (`0.0.0.0/0` → NAT). Flow logs are optional and require an existing SLS project/logstore.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Enable flow logs:

```bash
terraform apply \
  -var='enable_flow_log=true' \
  -var='flow_log_project=my-sls-project' \
  -var='flow_log_logstore=vpc-flow'
```
