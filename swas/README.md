# SWAS Module

Creates Alibaba Cloud Simple Application Server (轻量应用服务器) instances and optional firewall rules.

## Features

- `for_each` map of `alicloud_simple_application_server_instance`
- Required `image_id` / `plan_id`; optional `payment_type`, `period`, `data_disk_size`
- Optional `alicloud_simple_application_server_firewall_rule` map
- Outputs for instance IDs and public/private IPs when attributes exist
- Tag locals follow ManagedBy / Module / Project / Environment convention

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single SWAS instance |
| `examples/complete` | Multiple instances + firewall rules |

## Usage

```hcl
data "alicloud_simple_application_server_images" "linux" {
  platform = "Linux"
}

data "alicloud_simple_application_server_plans" "linux" {
  platform = "Linux"
}

module "swas" {
  source = "../swas"

  instances = {
    web-1 = {
      image_id       = data.alicloud_simple_application_server_images.linux.images[0].id
      plan_id        = data.alicloud_simple_application_server_plans.linux.plans[0].id
      payment_type   = "Subscription"
      period         = 1
      data_disk_size = 20
    }
  }

  firewall_rules = {
    https = {
      instance_key  = "web-1"
      rule_protocol = "Tcp"
      port          = "443/443"
    }
  }

  project     = "my-project"
  environment = "development"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
