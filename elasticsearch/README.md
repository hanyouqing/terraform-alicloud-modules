# Elasticsearch Module

Enterprise-grade Alibaba Cloud Elasticsearch (搜索) instances with private networking, disk encryption, and Kibana private access.

## Features

- Create multiple instances via `for_each` (`alicloud_elasticsearch_instance`)
- Required per instance: `version`, `vswitch_id`
- Password is assigned on the resource (provider-sensitive); the instances map is **not** marked sensitive as a whole
- Production-oriented defaults: disk encryption, no public endpoint, private whitelist, Kibana private preferred
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Minimal PostPaid instance |
| `examples/complete` | Production: encrypted disks, private whitelist, Kibana private, `data_node_amount >= 2` |

## Usage

```hcl
module "elasticsearch" {
  source = "../elasticsearch"

  default_private_whitelist = ["10.0.0.0/16"]

  instances = {
    search = {
      version                  = "7.10_with_X-Pack"
      vswitch_id               = "vsw-xxxxx"
      password                 = var.es_password
      description              = "app-search"
      instance_charge_type     = "PostPaid"
      data_node_amount         = 2
      data_node_disk_encrypted = true
      enable_public            = false
      enable_kibana_private_network = true
      enable_kibana_public_network  = false
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
| [alicloud_elasticsearch_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/elasticsearch_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances | Map of Elasticsearch instances | `map(object(...))` | `{}` | no |
| default_private_whitelist | Default private whitelist CIDRs | `list(string)` | `["10.0.0.0/8"]` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | Instance IDs |
| domain | Private domains |
| port | Ports |
| kibana_domain | Public Kibana domains |
| kibana_private_domain | Private Kibana domains |
| kibana_port | Kibana ports |
| status | Instance status |
| zzz_reminders | Operational reminders |
<!-- END_TF_DOCS -->
