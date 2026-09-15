output "instance_id" {
  description = "Bastionhost instance ID (created or provided)"
  value       = local.instance_id
}

output "user_ids" {
  description = "Map of Bastionhost user IDs"
  value       = { for k, v in alicloud_bastionhost_user.this : k => v.user_id }
}

output "user_group_ids" {
  description = "Map of Bastionhost user group IDs"
  value       = { for k, v in alicloud_bastionhost_user_group.this : k => v.user_group_id }
}

output "host_ids" {
  description = "Map of Bastionhost host IDs"
  value       = { for k, v in alicloud_bastionhost_host.this : k => v.host_id }
}

output "host_account_ids" {
  description = "Map of Bastionhost host account IDs"
  value       = { for k, v in alicloud_bastionhost_host_account.this : k => v.host_account_id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Bastionhost module"
  value = {
    next_steps = [
      "Bastionhost is a paid subscription product; use create_instance=false + instance_id to skip provisioning in unpaid sandboxes",
      "Register hosts and host accounts, then attach accounts to users or user groups",
      "Prefer private host addresses and disable public Bastionhost access unless required",
      "Rotate Local user passwords and host account credentials outside of Terraform state when possible"
    ]
    verification = [
      "Instance ID: ${local.instance_id != null ? local.instance_id : "n/a"}",
      "Users: ${length(alicloud_bastionhost_user.this)}",
      "Hosts: ${length(alicloud_bastionhost_host.this)}"
    ]
    security_notes = [
      "Terraform cannot destroy subscription Bastionhost instances; destroy only removes them from state",
      "Keep security groups least-privilege for Bastionhost ENI access to targets",
      "Empty users/hosts maps are valid for instance-only provisioning"
    ]
    cost_optimization = [
      "Right-size license_code asset quota",
      "Choose cloudbastion vs HA plan based on availability needs",
      "Avoid enabling public access and large public_white_list"
    ]
    important_resources = {
      instance_id  = local.instance_id
      user_count   = length(alicloud_bastionhost_user.this)
      host_count   = length(alicloud_bastionhost_host.this)
      created_here = var.create_instance
    }
  }
}
