# ECS Complete Example

Multi-instance ECS map with encrypted disks, optional public bandwidth, and deletion protection. Pass `instances` via tfvars.

## Usage

Create `terraform.tfvars`:

```hcl
instances = {
  web-1 = {
    image_id                   = "m-xxxxxxxx"
    instance_type              = "ecs.g7.large"
    vswitch_id                 = "vsw-xxxxxxxx"
    security_groups            = ["sg-xxxxxxxx"]
    key_name                   = "my-keypair"
    deletion_protection        = true
    internet_max_bandwidth_out = 0
    system_disk = {
      category  = "cloud_essd"
      size      = 40
      encrypted = true
    }
    data_disks = [
      {
        name      = "data-1"
        size      = 100
        category  = "cloud_essd"
        encrypted = true
      }
    ]
  }
}
```

```bash
terraform init
terraform plan
terraform apply
```
