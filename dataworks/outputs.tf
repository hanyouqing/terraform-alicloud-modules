output "project_id" {
  description = "DataWorks project ID"
  value       = try(alicloud_data_works_project.this[0].id, null)
}

output "project_name" {
  description = "DataWorks project name"
  value       = try(alicloud_data_works_project.this[0].project_name, null)
}

output "resource_group_ids" {
  description = "DataWorks DW resource group IDs"
  value       = { for k, v in alicloud_data_works_dw_resource_group.this : k => v.id }
}

output "member_ids" {
  description = "Project member resource IDs"
  value       = { for k, v in alicloud_data_works_project_member.this : k => v.id }
}

output "zzz_reminders" {
  description = "Reminders for DataWorks"
  value = {
    next_steps = [
      "Create workflows / DI jobs in console or via additional TF resources",
      "Attach dw_resource_groups on VPC for exclusive compute when needed",
      "Enable pai_task_enabled when integrating with PAI workspaces",
    ]
    security_notes = [
      "Prefer private VPC resource groups",
      "Assign least-privilege project member roles",
    ]
    important_resources = {
      project_id           = try(alicloud_data_works_project.this[0].id, null)
      resource_group_count = length(alicloud_data_works_dw_resource_group.this)
      member_count         = length(alicloud_data_works_project_member.this)
    }
  }
}
