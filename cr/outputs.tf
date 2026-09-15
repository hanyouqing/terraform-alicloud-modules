output "ee_instance_id" {
  description = "Container Registry Enterprise Edition instance ID"
  value       = local.ee_instance_id_effective
}

output "ee_instance_status" {
  description = "CR EE instance status when created by this module"
  value       = var.create_ee_instance ? alicloud_cr_ee_instance.this[0].status : null
}

output "namespace_names" {
  description = "Map of namespace names (Personal or EE)"
  value = local.ee_enabled ? (
    { for k, v in alicloud_cr_ee_namespace.this : k => v.name }
    ) : (
    { for k, v in alicloud_cr_namespace.this : k => v.name }
  )
}

output "repo_ids" {
  description = "Map of repository IDs (Personal: namespace/name; EE: instance::namespace:name style id)"
  value = local.ee_enabled ? (
    { for k, v in alicloud_cr_ee_repo.this : k => v.id }
    ) : (
    { for k, v in alicloud_cr_repo.this : k => v.id }
  )
}

output "ee_repo_ids" {
  description = "Map of EE repository repo_id attributes (null for Personal Edition)"
  value = local.ee_enabled ? (
    { for k, v in alicloud_cr_ee_repo.this : k => v.repo_id }
  ) : {}
}

output "endpoint_acl_policy_ids" {
  description = "Map of CR EE endpoint ACL policy IDs"
  value       = { for k, v in alicloud_cr_endpoint_acl_policy.this : k => v.id }
}

output "edition" {
  description = "Active registry edition: personal or enterprise"
  value       = local.ee_enabled ? "enterprise" : "personal"
}

output "zzz_reminders" {
  description = "Operational reminders for Container Registry and CI/CD"
  value = {
    next_steps = [
      "Set a registry login password in the CR console (Personal Edition) or via ee_password before docker login",
      "Push images: docker login registry.<region>.aliyuncs.com (Personal) or the EE instance endpoint",
      "Alibaba Cloud Codeup / Yunxiao (代码仓库 / CI) have limited Terraform coverage — use this CR module for images and keep Git/CI in external systems or console",
      "Wire CI (GitHub Actions, GitLab, Yunxiao pipelines) to push to the namespace/repo created here",
      "For EE, enable VPC endpoints and ACL policies before exposing internet pulls"
    ]
    verification = [
      "List Personal namespaces: aliyun cr GetNamespaceList",
      "List EE namespaces: aliyun cr ListNamespace --InstanceId <ee_instance_id>",
      "docker pull <endpoint>/<namespace>/<repo>:<tag>"
    ]
    security_notes = [
      "Default repositories are PRIVATE; avoid PUBLIC for production images",
      "Rotate registry credentials; prefer RAM roles / temporary tokens in CI",
      "Personal Edition resources are deprecated in the provider — plan migration to EE for long-lived production"
    ]
    cost_optimization = [
      "Personal Edition is free-tier oriented; EE is Subscription — create only when needed",
      "Prune unused tags and enable lifecycle rules in console/EE policies",
      "Restrict internet ACL CIDRs to CI egress ranges"
    ]
    important_resources = {
      edition            = local.ee_enabled ? "enterprise" : "personal"
      ee_instance_id     = local.ee_instance_id_effective
      namespace_count    = length(var.namespaces)
      repo_count         = length(var.repos)
      endpoint_acl_count = length(alicloud_cr_endpoint_acl_policy.this)
    }
  }
}
