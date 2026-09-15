# SLS Module

Simple Log Service (SLS) module for Alibaba Cloud projects, log stores, and optional indexes.

## Features

- `alicloud_log_project`
- `alicloud_log_store` with retention, shard_count, and auto_split
- Optional `alicloud_log_store_index` (full-text + field search)
- Production tagging: `Project`, `Environment`, `ManagedBy=terraform`, `Module=...`

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Project + one log store |
| `examples/complete` | Multiple stores with indexes and longer retention |

## Usage

```hcl
module "sls" {
  source = "../sls"

  project_name = "app-logs-prod"

  log_stores = {
    access = {
      retention_period = 90
      shard_count      = 2
      auto_split       = true
      create_index     = true
      field_search = [
        { name = "status", type = "long" },
        { name = "method", type = "text" }
      ]
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
