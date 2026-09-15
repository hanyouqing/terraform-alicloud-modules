# CMS Module

Enterprise CloudMonitor (CMS) alerting for Alibaba Cloud: contacts, contact groups, metric alarms, optional site monitors and monitor groups.

## Features

- `alicloud_cms_alarm_contact` (`for_each`)
- `alicloud_cms_alarm_contact_group` with contact name resolution
- `alicloud_cms_alarm` metric alarms via `escalations_critical` (statistics / comparison_operator / threshold)
- Optional `alicloud_cms_site_monitor` and `alicloud_cms_monitor_group`
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

**Production note:** route alerts through **contact groups** (DingTalk/webhook/email). Avoid paging individuals via SMS spam.

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Contact group + one CPU metric alarm |
| `examples/complete` | Contacts, groups, multi-severity alarms, site monitor, monitor group |

## Usage

```hcl
module "cms" {
  source = "../cms"

  contacts = {
    oncall = {
      describe      = "Primary on-call"
      channels_mail = "ops@example.com"
    }
  }

  contact_groups = {
    ops = {
      describe = "Operations"
      contacts = ["oncall"]
    }
  }

  alarms = {
    ecs-cpu = {
      project             = "acs_ecs_dashboard"
      metric              = "CPUUtilization"
      contact_groups      = ["ops"]
      statistics          = "Average"
      comparison_operator = ">="
      threshold           = "80"
      dimensions = [{
        instanceId = "i-xxxxx"
      }]
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
<!-- END_TF_DOCS -->
