# CI/CD complete example

CR namespaces + repos, CI assume-role with CR push policy, optional ECS image pipelines.

Git hosting / Yunxiao / GitHub Actions orchestration remains out-of-band — use `ci_role_arn` from outputs.

Replace `ci_assume_role_policy_document` with a real OIDC or account trust policy before apply.

```bash
terraform init
terraform plan
```
