# ActionTrail Complete Example

OSS trail (optional organization trail) plus an SLS delivery trail.

## Usage

```bash
terraform init
terraform plan \
  -var='oss_bucket_name=my-audit-trail-bucket' \
  -var='sls_project_arn=acs:log:cn-hangzhou:123456789012****:project/audit-logs' \
  -var='is_organization_trail=false'
```
