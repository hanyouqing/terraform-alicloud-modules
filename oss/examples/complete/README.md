# OSS Complete Example

Multi-bucket configuration demonstrating lifecycle rules, logging, and encryption options.

## Usage

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Provide a `terraform.tfvars` with unique bucket names and optional KMS key IDs.
