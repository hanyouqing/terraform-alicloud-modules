# CloudSSO Complete Example

Creates users, groups, System/Inline access configurations, and an optional assignment to a Resource Directory member account.

## Usage

```bash
terraform init
terraform plan \
  -var='directory_id=d-xxxxxxxxxx' \
  -var='target_account_id=1234567890123456'
terraform apply \
  -var='directory_id=d-xxxxxxxxxx' \
  -var='target_account_id=1234567890123456'
```
