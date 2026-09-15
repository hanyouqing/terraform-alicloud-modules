output "vvp_instance_id" {
  description = "Realtime Compute VVP instance ID"
  value       = try(alicloud_realtime_compute_vvp_instance.this[0].id, null)
}

output "vvp_resource_id" {
  description = "VVP resource/workspace ID used by deployments"
  value       = local.vvp_resource_id
}

output "vvp_instance_status" {
  description = "VVP instance status"
  value       = try(alicloud_realtime_compute_vvp_instance.this[0].status, null)
}

output "deployment_ids" {
  description = "Deployment IDs keyed by map key"
  value       = { for k, v in alicloud_realtime_compute_deployment.this : k => v.id }
}

output "deployment_deployment_ids" {
  description = "Provider deployment_id attribute keyed by map key"
  value       = { for k, v in alicloud_realtime_compute_deployment.this : k => v.deployment_id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the Realtime Compute module"
  value = {
    next_steps = [
      "Ensure the OSS storage bucket exists and RAM roles for Flink can access it",
      "Size resource_spec (cpu / memory_gb) for production CU needs",
      "Deployments need namespace + deployment_target; attach artifact when submitting jobs",
      "Validate zone_id matches the chosen vSwitch zone",
    ]
    verification = [
      "aliyun foasconsole ListInstances --RegionId <region>",
      "Check VVP instance ${try(alicloud_realtime_compute_vvp_instance.this[0].id, "N/A")} in Realtime Compute console",
    ]
    security_notes = [
      "Tags include ManagedBy/Module/Project/Environment on the VVP instance",
      "Prefer private VPC binding; do not expose Flink UIs publicly",
      "Provider schema marks storage required on create — always pass storage.oss_bucket",
    ]
    important_resources = {
      vvp_created      = var.create_vvp_instance
      deployment_count = length(alicloud_realtime_compute_deployment.this)
    }
  }
}
