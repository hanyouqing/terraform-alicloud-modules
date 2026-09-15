# ActionTrail Basic Example

Single-account trail delivering events to an existing OSS bucket.

## Usage

```bash
terraform init
terraform plan \
  -var='oss_bucket_name=my-audit-trail-bucket' \
  -var='oss_write_role_arn=acs:ram::123456789012****:role/aliyunserviceroleforactiontrail'
```
