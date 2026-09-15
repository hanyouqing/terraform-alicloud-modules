# OSS Basic Example

Creates a single private, encrypted, versioned OSS bucket with force SSL.

## Usage

```bash
terraform init
terraform plan -var="bucket_name=my-unique-bucket-name"
terraform apply -var="bucket_name=my-unique-bucket-name"
```
