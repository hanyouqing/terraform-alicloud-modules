output "resource_group_ids" {
  description = "Map of resource group keys to IDs"
  value       = { for k, v in alicloud_resource_manager_resource_group.this : k => v.id }
}

output "names" {
  description = "Map of resource group keys to resource_group_name"
  value       = { for k, v in alicloud_resource_manager_resource_group.this : k => v.resource_group_name }
}

output "display_names" {
  description = "Map of resource group keys to display names"
  value       = { for k, v in alicloud_resource_manager_resource_group.this : k => v.display_name }
}

output "zzz_reminders" {
  description = "Operational reminders for Resource Groups"
  value = {
    next_steps = [
      "Assign RAM policies / resource group authorization for least-privilege operators",
      "Move existing resources into groups via console or resource-group move APIs where needed"
    ]
    security_notes = [
      "Resource groups are account-scoped isolation units, not a substitute for Resource Directory folders"
    ]
    production_note = "Use stable resource_group_name values; renaming may require recreation depending on API behavior."
    important_resources = {
      resource_group_count = length(alicloud_resource_manager_resource_group.this)
    }
  }
}
