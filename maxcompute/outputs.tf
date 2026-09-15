output "project_ids" {
  description = "MaxCompute project IDs keyed by map key"
  value       = { for k, v in alicloud_maxcompute_project.this : k => v.id }
}

output "project_names" {
  description = "MaxCompute project names keyed by map key"
  value       = { for k, v in alicloud_maxcompute_project.this : k => v.project_name }
}

output "status" {
  description = "MaxCompute project status keyed by map key"
  value       = { for k, v in alicloud_maxcompute_project.this : k => v.status }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the MaxCompute module"
  value = {
    next_steps = [
      "Bind a default_quota (pay-as-you-go or subscription CU) before heavy workloads",
      "Restrict access with ip_white_list (public and/or VPC) and security_properties",
      "Enable properties.encryption for sensitive warehouses",
      "Grant RAM / MaxCompute ACL roles to analysts and pipelines separately",
    ]
    verification = [
      "aliyun maxcompute ListProjects --RegionId <region>",
      "aliyun maxcompute GetProject --ProjectName ${length(alicloud_maxcompute_project.this) > 0 ? values(alicloud_maxcompute_project.this)[0].project_name : "N/A"}",
    ]
    security_notes = [
      "Tags include ManagedBy/Module/Project/Environment",
      "Prefer VPC IP whitelist over open public IP lists",
      "project_protection can block destructive DDL — enable for production",
    ]
    important_resources = {
      project_count = length(alicloud_maxcompute_project.this)
    }
  }
}
