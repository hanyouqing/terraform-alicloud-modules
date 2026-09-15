# ECS Basic Example

Single private ECS instance with encrypted ESSD system disk and no public IP.

## Usage

```bash
terraform init
terraform apply \
  -var='image_id=m-xxxxxxxx' \
  -var='vswitch_id=vsw-xxxxxxxx' \
  -var='security_groups=["sg-xxxxxxxx"]' \
  -var='key_name=my-keypair'
```
