# RDS Complete Example

Creates RDS with Multi-AZ options, custom backup policy, encryption, and optional accounts.

## Usage

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Keep `account_password` out of VCS; pass via env (`TF_VAR_accounts`) or a secrets-backed tfvars file.
