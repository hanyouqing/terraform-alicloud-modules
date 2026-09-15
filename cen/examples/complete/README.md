# CEN Complete Example

CEN with optional cross-region bandwidth package/limits and optional transit router VPC attachments. For overseas Express Connect (高速通道) VBRs, attach `child_instance_type = "VBR"` and provision the circuit via an express-connect module.

## Usage

```bash
terraform apply \
  -var='attachments={hz={child_instance_id="vpc-a",child_instance_type="VPC",child_instance_region_id="cn-hangzhou"},sh={child_instance_id="vpc-b",child_instance_type="VPC",child_instance_region_id="cn-shanghai"}}' \
  -var='bandwidth_limits={hz-sh={region_ids=["cn-hangzhou","cn-shanghai"],bandwidth_limit=2}}'
```
