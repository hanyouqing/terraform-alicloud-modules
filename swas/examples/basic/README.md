# SWAS Basic Example

Single Simple Application Server instance.

## Usage

```bash
terraform init
terraform apply \
  -var='image_id=xxxxxxxx' \
  -var='plan_id=swas.s2.c2m1s40b3.linux'
```

Discover IDs with:

```hcl
data "alicloud_simple_application_server_images" "linux" { platform = "Linux" }
data "alicloud_simple_application_server_plans" "linux" { platform = "Linux" }
```
