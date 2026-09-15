output "workspace_id" {
  description = "PAI workspace ID"
  value       = alicloud_pai_workspace_workspace.this.id
}

output "workspace_name" {
  description = "PAI workspace name"
  value       = alicloud_pai_workspace_workspace.this.workspace_name
}

output "workspace_status" {
  description = "PAI workspace status"
  value       = alicloud_pai_workspace_workspace.this.status
}

output "dataset_ids" {
  description = "PAI dataset IDs keyed by map key"
  value       = { for k, v in alicloud_pai_workspace_dataset.this : k => v.id }
}

output "model_ids" {
  description = "PAI model IDs keyed by map key"
  value       = { for k, v in alicloud_pai_workspace_model.this : k => v.id }
}

output "service_ids" {
  description = "PAI service IDs keyed by map key"
  value       = { for k, v in alicloud_pai_service.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the PAI module"
  value = {
    next_steps = [
      "Use this workspace for custom model training, datasets, and PAI online serving",
      "DashScope / Bailian (通义) LLM API keys are console / out-of-band — not managed by this module",
      "Store model artifacts and dataset URIs in OSS; grant PAI workspace RAM access",
      "service_config is a flexible JSON string — validate against PAI EAS docs before apply",
    ]
    verification = [
      "aliyun pai ListWorkspaces --RegionId <region>",
      "aliyun pai GetWorkspace --WorkspaceId ${alicloud_pai_workspace_workspace.this.id}",
    ]
    security_notes = [
      "Workspace / dataset / model resources do not support tags in the provider schema",
      "pai_service tags include ManagedBy/Module/Project/Environment",
      "Do not commit DashScope API keys; rotate via console or secrets manager",
    ]
    important_resources = {
      workspace_id  = alicloud_pai_workspace_workspace.this.id
      dataset_count = length(alicloud_pai_workspace_dataset.this)
      model_count   = length(alicloud_pai_workspace_model.this)
      service_count = length(alicloud_pai_service.this)
    }
    dashscope_note = "DashScope/Bailian LLM API access is out-of-band (console). PAI module covers custom training & serving infra only."
  }
}
