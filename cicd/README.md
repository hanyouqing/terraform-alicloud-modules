# CI/CD Foundation Module

Enterprise CI/CD **foundation** on Alibaba Cloud: Container Registry (Personal) namespaces/repos, optional ECS image pipelines, and a CI assume-role for registry push.

## Out of band (important)

The Alibaba Cloud Terraform provider does **not** fully cover Yunxiao / Codeup pipelines. This module does **not** provision:

- Git hosting (Codeup, GitHub, GitLab)
- Pipeline orchestration (Yunxiao, GitHub Actions, GitLab CI)

Configure those systems to push images to CR and assume the CI RAM role created here. This module provisions **registries**, **image pipelines**, and **CI identity** only.

## Features

- `alicloud_cr_namespace` + `alicloud_cr_repo` for_each (artifact registry)
- Optional `alicloud_ecs_image_pipeline` for_each (VM image builds)
- Optional `alicloud_ram_role` with trust document + inline/custom CR push policy (or attachable system policies)
- Standard tagging: ManagedBy, Module, Project, Environment

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Namespace + one repo |
| `examples/complete` | Namespace, repos, CI role, optional image pipeline |

## Usage

```hcl
module "cicd" {
  source = "../cicd"

  namespaces = {
    myapp = {
      auto_create        = false
      default_visibility = "PRIVATE"
    }
  }

  repos = {
    api = {
      namespace_key = "myapp"
      summary       = "API images"
      repo_type     = "PRIVATE"
    }
  }

  create_ci_role                  = true
  ci_role_name                    = "ci-github-actions"
  ci_assume_role_policy_document  = var.ci_trust_policy
  # ci_policy_document            = var.custom_cr_policy # optional override

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
| [alicloud_cr_namespace.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cr_namespace) | resource |
| [alicloud_cr_repo.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cr_repo) | resource |
| [alicloud_ecs_image_pipeline.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_image_pipeline) | resource |
| [alicloud_ram_role.ci](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role) | resource |
| [alicloud_ram_policy.ci](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_policy) | resource |
| [alicloud_ram_role_policy_attachment.ci_custom](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role_policy_attachment) | resource |
| [alicloud_ram_role_policy_attachment.ci_extra](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespaces | CR namespaces | `map(object(...))` | `{}` | no |
| repos | CR repos | `map(object(...))` | `{}` | no |
| image_pipelines | Optional ECS image pipelines | `map(object(...))` | `{}` | no |
| create_ci_role | Create CI assume-role | `bool` | `false` | no |
| ci_assume_role_policy_document | Trust policy | `string` | `null` | no |
| ci_policy_document | Optional custom CR push policy | `string` | `null` | no |
| project | Project tag | `string` | `"alicloud-modules"` | no |
| environment | Environment tag | `string` | `"development"` | no |
| tags | Extra tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace_names | Namespace names |
| repo_ids / repo_names | Repository identifiers |
| image_pipeline_ids | Image pipeline IDs |
| ci_role_name / ci_role_arn | CI identity |
| zzz_reminders | Scope and next steps |
<!-- END_TF_DOCS -->
