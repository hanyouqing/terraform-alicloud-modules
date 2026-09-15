output "namespace_names" {
  description = "CR namespace names"
  value       = { for k, v in alicloud_cr_namespace.this : k => v.name }
}

output "repo_ids" {
  description = "CR repository IDs"
  value       = { for k, v in alicloud_cr_repo.this : k => v.id }
}

output "repo_names" {
  description = "CR repository names"
  value       = { for k, v in alicloud_cr_repo.this : k => v.name }
}

output "repo_domain_list" {
  description = "CR repository domain lists when present"
  value       = { for k, v in alicloud_cr_repo.this : k => try(v.domain_list, null) }
}

output "image_pipeline_ids" {
  description = "ECS image pipeline IDs"
  value       = { for k, v in alicloud_ecs_image_pipeline.this : k => v.id }
}

output "ci_role_name" {
  description = "CI RAM role name"
  value       = try(alicloud_ram_role.ci[0].role_name, null)
}

output "ci_role_arn" {
  description = "CI RAM role ARN"
  value       = try(alicloud_ram_role.ci[0].arn, null)
}

output "ci_policy_name" {
  description = "CI custom policy name"
  value       = try(alicloud_ram_policy.ci[0].policy_name, null)
}

output "zzz_reminders" {
  description = "Important reminders for the CI/CD foundation module"
  value = {
    scope = [
      "This module provisions artifact registries (CR Personal), optional ECS image pipelines, and CI assume-role identity.",
      "Git hosting and pipeline orchestration (Codeup / Yunxiao / GitHub Actions / GitLab CI) are out-of-band — configure those separately to push to CR and assume the CI role.",
    ]
    next_steps = [
      "Wire OIDC or long-lived credentials in your CI system to assume ci_role_arn",
      "docker login / buildx push to CR Personal endpoints from pipelines",
      "Execute image pipelines via console/API or alicloud_ecs_image_pipeline_execution when needed",
      "Prefer EE CR (see cr module) for enterprise multi-tenant registries",
    ]
    verification = [
      "aliyun cr GetNamespace --Namespace <name>",
      "aliyun cr GetRepoList --Namespace <name>",
      "aliyun ram GetRole --RoleName ${try(alicloud_ram_role.ci[0].role_name, "N/A")}",
    ]
    security_notes = [
      "Default CI policy grants CR pull/push; tighten Resource ARNs for production",
      "Trust policy (ci_assume_role_policy_document) must restrict principals (OIDC aud/sub)",
    ]
    important_resources = {
      namespace_count      = length(alicloud_cr_namespace.this)
      repo_count           = length(alicloud_cr_repo.this)
      image_pipeline_count = length(alicloud_ecs_image_pipeline.this)
      ci_role_created      = var.create_ci_role
    }
  }
}
