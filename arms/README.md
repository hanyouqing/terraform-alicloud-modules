# ARMS Module

Enterprise Alibaba Cloud ARMS foundation: Grafana workspace (optional), Prometheus, optional environments and alert contacts.

## Features

- Optional `alicloud_arms_grafana_workspace`
- `alicloud_arms_prometheus` for_each (`cluster_type` e.g. `remote-write`, `ecs`)
- `grafana_instance_id` from created workspace **or** existing `var.grafana_instance_id` / per-entry override (Prometheus always requires it)
- Optional `alicloud_arms_environment`
- Optional alert contacts + contact groups
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Prometheus with existing/free Grafana instance ID |
| `examples/complete` | Grafana workspace + Prometheus + environment + contacts |

## Usage

```hcl
module "arms" {
  source = "../arms"

  create_grafana_workspace = true
  grafana_workspace_name   = "prod-grafana"
  grafana_workspace_edition = "standard"

  prometheus = {
    rw = {
      cluster_type = "remote-write"
      cluster_name = "prod-rw"
    }
  }

  project     = "my-project"
  environment = "production"
}

# Or reuse an existing Grafana workspace / free instance:
module "arms_existing_grafana" {
  source = "../arms"

  grafana_instance_id = "gw-xxxxx" # or "free" when applicable

  prometheus = {
    ecs = {
      cluster_type      = "ecs"
      cluster_name      = "ecs-prom"
      vpc_id            = "vpc-xxxxx"
      vswitch_id        = "vsw-xxxxx"
      security_group_id = "sg-xxxxx"
    }
  }
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
| [alicloud_arms_grafana_workspace.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_grafana_workspace) | resource |
| [alicloud_arms_prometheus.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_prometheus) | resource |
| [alicloud_arms_environment.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_environment) | resource |
| [alicloud_arms_alert_contact.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_alert_contact) | resource |
| [alicloud_arms_alert_contact_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_alert_contact_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_grafana_workspace | Create Grafana workspace | `bool` | `false` | no |
| grafana_instance_id | Existing Grafana ID when not creating | `string` | `null` | no |
| prometheus | Prometheus map | `map(object(...))` | `{}` | no |
| environments | Optional environments | `map(object(...))` | `{}` | no |
| alert_contacts | Optional contacts | `map(object(...))` | `{}` | no |
| alert_contact_groups | Optional contact groups | `map(object(...))` | `{}` | no |
| project | Project tag | `string` | `"alicloud-modules"` | no |
| environment | Environment tag | `string` | `"development"` | no |
| tags | Extra tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| prometheus_ids | Prometheus IDs |
| grafana_workspace_id | Grafana workspace ID |
| environment_ids | Environment IDs |
| zzz_reminders | Operational reminders (instrument apps, ACK addon) |
<!-- END_TF_DOCS -->
