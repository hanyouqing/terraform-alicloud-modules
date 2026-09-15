# Container Registry Module (容器镜像服务)

Manages Alibaba Cloud Container Registry namespaces and repositories for CI/CD image artifacts. Supports **Personal Edition** (default) and **Enterprise Edition** via `create_ee_instance`.

## Features

- Personal Edition: `alicloud_cr_namespace` + `alicloud_cr_repo` (`for_each`)
- Enterprise Edition: optional `alicloud_cr_ee_instance`, `alicloud_cr_ee_namespace`, `alicloud_cr_ee_repo`
- Optional `alicloud_cr_endpoint_acl_policy` for EE internet ACL
- Production tagging on EE instances

## Codeup / Yunxiao note

Alibaba Cloud **Codeup** (代码仓库) and **Yunxiao** (云效 CI/CD) have **limited Terraform coverage**. Use this module for the **image registry** side; keep Git remotes and pipeline definitions in console, GitHub/GitLab, or other IaC. Typical pattern: external Git → CI build → `docker push` to CR namespaces/repos created here.

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | Personal Edition namespace + private repo |
| `examples/complete` | Multiple namespaces/repos; optional EE + ACL |

## Usage (Personal Edition)

```hcl
module "cr" {
  source = "../cr"

  create_ee_instance = false

  namespaces = {
    app = {
      auto_create        = false
      default_visibility = "PRIVATE"
    }
  }

  repos = {
    api = {
      namespace_key = "app"
      summary      = "API service images"
      repo_type    = "PRIVATE"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Usage (Enterprise Edition)

```hcl
module "cr" {
  source = "../cr"

  create_ee_instance = true
  ee_instance_name   = "prod-cr"
  ee_instance_type   = "Basic"
  ee_period          = 1

  namespaces = {
    app = { default_visibility = "PRIVATE" }
  }

  repos = {
    api = {
      namespace_key = "app"
      summary      = "API images"
      repo_type    = "PRIVATE"
    }
  }

  endpoint_acl_policies = {
    office = {
      entry       = "203.0.113.0/24"
      description = "office egress"
    }
  }
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- Set a registry password in console (Personal) or `ee_password` (EE) before `docker login`

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
