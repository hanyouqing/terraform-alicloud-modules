output "prometheus_ids" {
  description = "ARMS Prometheus instance IDs"
  value       = { for k, v in alicloud_arms_prometheus.this : k => v.id }
}

output "prometheus_cluster_ids" {
  description = "Prometheus cluster IDs when present"
  value       = { for k, v in alicloud_arms_prometheus.this : k => try(v.cluster_id, null) }
}

output "grafana_workspace_id" {
  description = "Grafana workspace ID (created or provided)"
  value       = local.grafana_instance_id_effective
}

output "environment_ids" {
  description = "ARMS environment IDs"
  value       = { for k, v in alicloud_arms_environment.this : k => v.id }
}

output "alert_contact_ids" {
  description = "Alert contact IDs"
  value       = { for k, v in alicloud_arms_alert_contact.this : k => v.id }
}

output "alert_contact_group_ids" {
  description = "Alert contact group IDs"
  value       = { for k, v in alicloud_arms_alert_contact_group.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the ARMS module"
  value = {
    next_steps = [
      "Instrument applications with OpenTelemetry / ARMS agents",
      "For ACK: install ARMS / Prometheus monitoring addon and bind environment",
      "Configure remote-write or ECS scrape targets as needed",
      "Wire alert contact groups into dispatch rules in console if not managed here",
    ]
    verification = [
      "aliyun arms ListPrometheusInstances --RegionId <region>",
      "aliyun arms ListEnvironments --RegionId <region>",
    ]
    security_notes = [
      "Prefer private VPC Prometheus (ecs/remote-write) over public scrapers",
      "Grafana instance ID is always required by Prometheus; reuse an existing workspace when possible",
    ]
    important_resources = {
      prometheus_count  = length(alicloud_arms_prometheus.this)
      environment_count = length(alicloud_arms_environment.this)
      grafana_created   = var.create_grafana_workspace
    }
  }
}
