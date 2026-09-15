# Cloud Config Module

Enterprise [Cloud Config](https://www.alibabacloud.com/help/cloud-config) (配置审计) for single-account baselines and optional multi-account aggregation.

> Cloud Config control plane is available in **`cn-shanghai`** and **`ap-southeast-1`**. Point the provider region accordingly.

## Features

- Optional `alicloud_config_configuration_recorder`
- `alicloud_config_rule` via `for_each` (`rules` map)
- Optional `alicloud_config_compliance_pack`
- Optional multi-account: `alicloud_config_aggregator` + `alicloud_config_aggregate_config_rule`
- Basic example stays single-account; use aggregator for Landing Zone / Resource Directory

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Recorder + one managed rule (single account) |
| `examples/complete` | Rules + compliance pack + optional RD aggregator |

## Usage

```hcl
module "config" {
  source = "../config"

  create_configuration_recorder = true

  rules = {
    required-tags = {
      source_identifier         = "required-tags"
      source_owner              = "ALIYUN"
      risk_level                = 1
      config_rule_trigger_types = "ConfigurationItemChangeNotification"
      resource_types_scope      = ["ACS::ECS::Instance"]
      input_parameters = {
        key1 = "Environment"
      }
    }
  }

  project     = "my-project"
  environment = "production"
}
```

### Landing Zone (multi-account)

On the management or Config delegated-admin account:

```hcl
create_aggregator = true
aggregator_type   = "RD"

aggregate_rules = {
  required-tags = {
    source_identifier    = "required-tags"
    resource_types_scope = ["ACS::ECS::Instance"]
    input_parameters = {
      key1 = "Environment"
    }
  }
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
