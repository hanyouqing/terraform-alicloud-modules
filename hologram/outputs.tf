output "instance_ids" {
  description = "Hologres instance IDs keyed by map key"
  value       = { for k, v in alicloud_hologram_instance.this : k => v.id }
}

output "instance_names" {
  description = "Hologres instance names keyed by map key"
  value       = { for k, v in alicloud_hologram_instance.this : k => v.instance_name }
}

output "status" {
  description = "Instance status keyed by map key"
  value       = { for k, v in alicloud_hologram_instance.this : k => v.status }
}

output "endpoints" {
  description = "Instance endpoint blocks keyed by map key (when available)"
  value       = { for k, v in alicloud_hologram_instance.this : k => try(v.endpoints, null) }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Hologres module"
  value = {
    next_steps = [
      "Prefer enable_ssl=true for production clients",
      "Attach VPC endpoints (type VPC) with vpc_id + vswitch_id for private access",
      "Size cpu / storage_size for warehouse concurrency needs",
      "Connect via endpoints output after instance becomes Running",
    ]
    verification = [
      "aliyun hologram ListInstances --RegionId <region>",
      "aliyun hologram GetInstance --InstanceId ${length(alicloud_hologram_instance.this) > 0 ? values(alicloud_hologram_instance.this)[0].id : "N/A"}",
    ]
    security_notes = [
      "Tags include ManagedBy/Module/Project/Environment",
      "enable_ssl defaults unset in basic; complete example sets true",
      "Prefer VPC endpoints over public access for enterprise warehouses",
    ]
    important_resources = {
      instance_count = length(alicloud_hologram_instance.this)
    }
  }
}
