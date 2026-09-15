# Kafka Module

Enterprise-grade Alibaba Cloud Message Queue for Apache Kafka (alikafka) with topics, consumer groups, and optional SASL users.

## Features

- `alicloud_alikafka_instance` with `deploy_type = 5` (VPC) typical for enterprise
- Topics and consumer groups via `for_each`
- Optional SASL users via `for_each` (password sensitive on resource, not whole map)
- Optional `kms_key_id` for disk encryption, `security_group`, multi-zone `vswitch_ids`
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | VPC instance + one topic |
| `examples/complete` | Multi-zone vSwitches, SASL, topics + consumer groups |

## Usage

```hcl
module "kafka" {
  source = "../kafka"

  instance_name  = "app-kafka"
  deploy_type    = 5
  vpc_id         = "vpc-xxxxx"
  vswitch_ids    = ["vsw-a", "vsw-b"]
  security_group = "sg-xxxxx"
  kms_key_id     = "key-xxxxx"
  disk_size      = 500
  paid_type      = "PostPaid"

  topics = {
    orders = {
      remark        = "order events"
      partition_num = 6
    }
  }

  consumer_groups = {
    order-worker = {
      description = "order consumers"
    }
  }

  sasl_users = {
    app = {
      password = var.kafka_sasl_password
      type     = "plain"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| alicloud | ~> 1.292 |

## Providers

| Name | Version |
|------|---------|
| alicloud | ~> 1.292 |

## Resources

| Name | Type |
|------|------|
| [alicloud_alikafka_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alikafka_instance) | resource |
| [alicloud_alikafka_topic.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alikafka_topic) | resource |
| [alicloud_alikafka_consumer_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alikafka_consumer_group) | resource |
| [alicloud_alikafka_sasl_user.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alikafka_sasl_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_instance | Create Kafka instance | `bool` | `true` | no |
| instance_name | Instance name | `string` | `null` | no |
| deploy_type | 4=Internet, 5=VPC | `number` | `5` | no |
| vpc_id | VPC ID | `string` | `null` | no |
| vswitch_ids | Multi-zone vSwitch IDs | `list(string)` | `[]` | no |
| security_group | Security group ID | `string` | `null` | no |
| kms_key_id | Optional KMS key for disk encryption | `string` | `null` | no |
| topics | Topic map | `map(object(...))` | `{}` | no |
| consumer_groups | Consumer group map | `map(object(...))` | `{}` | no |
| sasl_users | Optional SASL users | `map(object(...))` | `{}` | no |
| project | Project tag | `string` | `"alicloud-modules"` | no |
| environment | Environment tag | `string` | `"development"` | no |
| tags | Extra tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | Instance ID |
| end_point / domain_endpoint / ssl_* / sasl_* | Endpoints when available |
| topic_names | Topic names |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
