# Function Compute 3.0 Module (Serverless)

Alibaba Cloud **Function Compute 3.0** (`alicloud_fcv3_*`) for serverless glue, async jobs, and event-driven AI pipelines.

> Good for LLM proxy glue and async jobs; pair with [PAI](../pai) (model serving) and [CR](../cr) (container images).

## Features

- Create multiple functions via `for_each` (`alicloud_fcv3_function`)
- Required per function: `handler`, `runtime`
- Code block: OSS (`oss_bucket_name` / `oss_object_name`) **or** inline `zip_file`
- Optional dynamic `vpc_config`, `log_config`, `gpu_config`
- Optional triggers (`alicloud_fcv3_trigger`) and custom domains
- Standard tagging on functions

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Single Python/runtime function with zip or OSS code |
| `examples/complete` | VPC + log + optional HTTP trigger + custom domain |

## Usage

```hcl
module "fcv3" {
  source = "../fcv3"

  functions = {
    llm-proxy = {
      handler = "index.handler"
      runtime = "python3.10"
      code = {
        oss_bucket_name = "my-fc-code"
        oss_object_name = "llm-proxy.zip"
      }
      timeout     = 60
      memory_size = 512
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
| [alicloud_fcv3_function.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/fcv3_function) | resource |
| [alicloud_fcv3_trigger.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/fcv3_trigger) | resource |
| [alicloud_fcv3_custom_domain.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/fcv3_custom_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| functions | Map of FC 3.0 functions | `map(object(...))` | `{}` | no |
| triggers | Optional triggers | `map(object(...))` | `{}` | no |
| custom_domains | Optional custom domains | `map(object(...))` | `{}` | no |
| project | Project name for tagging | `string` | `"alicloud-modules"` | no |
| environment | Environment name for tagging | `string` | `"development"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_names | FC 3.0 function names |
| function_ids | FC 3.0 function IDs |
| function_arns | FC 3.0 function ARNs |
| trigger_ids | FC 3.0 trigger IDs |
| trigger_http_urls | HTTP trigger URLs when present |
| custom_domain_ids | Custom domain IDs |
| zzz_reminders | Reminders for Function Compute 3.0 |
<!-- END_TF_DOCS -->
