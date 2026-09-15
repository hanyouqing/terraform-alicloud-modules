output "disk_ids" {
  description = "IDs of the ECS disks"
  value       = { for k, v in alicloud_ecs_disk.this : k => v.id }
}

output "disk_names" {
  description = "Names of the ECS disks"
  value       = { for k, v in alicloud_ecs_disk.this : k => v.disk_name }
}

output "attachments" {
  description = "Disk attachment IDs keyed by attachment map key"
  value       = { for k, v in alicloud_ecs_disk_attachment.this : k => v.id }
}

output "snapshot_policy_ids" {
  description = "IDs of created automatic snapshot policies"
  value       = { for k, v in alicloud_ecs_auto_snapshot_policy.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the disk module"
  value = {
    next_steps = [
      "Attach disks to ECS instances via attachments when ready",
      "Format and mount volumes inside the guest OS after attachment",
      "Confirm snapshot policies cover recovery RPO requirements",
      "Validate encryption and KMS key permissions for the ECS role",
    ]
    verification = [
      "aliyun ecs DescribeDisks --RegionId <region>",
      "aliyun ecs DescribeDisks --DiskIds '[\"${length(alicloud_ecs_disk.this) > 0 ? values(alicloud_ecs_disk.this)[0].id : "N/A"}\"]'",
    ]
    security_notes = [
      "Disks default to encrypted=true",
      "Prefer cloud_essd with an appropriate performance_level",
      "Restrict who can detach/delete disks via RAM",
    ]
    important_resources = {
      disk_count            = length(alicloud_ecs_disk.this)
      attachment_count      = length(alicloud_ecs_disk_attachment.this)
      snapshot_policy_count = length(alicloud_ecs_auto_snapshot_policy.this)
      snapshot_attach_count = length(alicloud_ecs_auto_snapshot_policy_attachment.this) + length(alicloud_ecs_auto_snapshot_policy_attachment.external)
    }
  }
}
