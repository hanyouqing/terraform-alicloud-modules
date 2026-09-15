# Redis Complete Example

Creates Redis/Tair instances with multi-zone options, SSL, auth mode, and backup/maintain windows.

## Usage

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Keep passwords out of VCS; pass via env or a secrets-backed tfvars file.
