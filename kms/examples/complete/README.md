# KMS Complete Example

CMK with automatic rotation, alias, and a secrets map. Secret values are never outputted.

## Usage

```bash
terraform init
terraform apply -var='app_secret=change-me'
```
