output "instance_ids" {
  description = "Map of ECS instance IDs"
  value       = { for k, v in alicloud_instance.this : k => v.id }
}

output "instance_names" {
  description = "Map of ECS instance names"
  value       = { for k, v in alicloud_instance.this : k => v.instance_name }
}

output "private_ips" {
  description = "Map of private IP addresses"
  value       = { for k, v in alicloud_instance.this : k => v.private_ip }
}

output "public_ips" {
  description = "Map of public IP addresses (empty string when none)"
  value       = { for k, v in alicloud_instance.this : k => v.public_ip }
}

output "availability_zones" {
  description = "Map of availability zones for each instance"
  value       = { for k, v in alicloud_instance.this : k => v.availability_zone }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the ECS module"
  value = {
    next_steps = [
      "Verify instances are Running in the ECS console or via aliyun ecs DescribeInstances",
      "Confirm security group rules allow required management and application traffic",
      "Prefer key_name over password; rotate credentials if password was used",
      "Enable deletion_protection for production instances",
      "Attach additional data disks or expand system disks as capacity requires"
    ]
    verification = [
      "List instances: aliyun ecs DescribeInstances --InstanceIds '[\"${length(alicloud_instance.this) > 0 ? values(alicloud_instance.this)[0].id : "N/A"}\"]'",
      "Check public/private IPs in outputs before configuring DNS or load balancers"
    ]
    security_notes = [
      "internet_max_bandwidth_out defaults to 0 (no public IP)",
      "System disks default to encrypted cloud_essd",
      "user_data and password changes are ignored after create to avoid unintended recreation",
      "Keep security groups least-privilege; avoid world-open SSH"
    ]
    cost_optimization = [
      "Right-size instance_type for workload",
      "Stop non-production instances when idle",
      "Use PL0 ESSD unless higher performance is required",
      "Avoid unused public bandwidth (keep internet_max_bandwidth_out at 0)"
    ]
    important_resources = {
      instance_count = length(alicloud_instance.this)
      instance_ids   = { for k, v in alicloud_instance.this : k => v.id }
      private_ips    = { for k, v in alicloud_instance.this : k => v.private_ip }
      public_ips     = { for k, v in alicloud_instance.this : k => v.public_ip if v.public_ip != null && v.public_ip != "" }
    }
  }
}
