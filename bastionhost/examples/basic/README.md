# Bastionhost Basic Example

Instance-only workflow. Defaults to `create_instance=false` so unpaid sandboxes can pass an existing `instance_id` (or leave empty maps with no create).

## Usage

```bash
# Skip paid create (no-op resources beyond locals/checks when maps empty and create_instance=false needs instance_id)
terraform apply -var='create_instance=false' -var='instance_id=bastionhost-cn-xxxxx'

# Or create a paid instance
terraform apply \
  -var='create_instance=true' \
  -var='vswitch_id=vsw-xxxxxxxx' \
  -var='security_group_ids=["sg-xxxxxxxx"]' \
  -var='license_code=bhah_ent_50_asset'
```
