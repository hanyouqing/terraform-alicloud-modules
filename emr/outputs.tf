output "cluster_id" {
  description = "EMR v2 cluster ID"
  value       = try(alicloud_emrv2_cluster.this[0].id, null)
}

output "security_mode" {
  description = "Cluster security mode"
  value       = try(alicloud_emrv2_cluster.this[0].security_mode, null)
}

output "payment_type" {
  description = "Cluster payment type"
  value       = try(alicloud_emrv2_cluster.this[0].payment_type, null)
}

output "zzz_reminders" {
  description = "Cost and security reminders for EMR clusters"
  value = {
    next_steps = [
      "Confirm release_version and applications match your Spark/Hive workload",
      "Use private vSwitches only; keep with_public_ip=false",
      "Destroy idle clusters promptly — EMR node groups are expensive",
    ]
    cost_warning = [
      "EMR clusters bill for every ECS node continuously while running",
      "Prefer PayAsYouGo for short demos; stop or destroy when idle",
      "MASTER + CORE node groups multiply cost quickly",
    ]
    security_mode = try(alicloud_emrv2_cluster.this[0].security_mode, var.security_mode)
    security_notes = [
      "disk encryption defaults enabled on node_attributes when set",
      "Prefer security_mode=KERBEROS for production multi-tenant clusters",
      "deletion_protection=true in complete examples",
    ]
    important_resources = {
      cluster_id = try(alicloud_emrv2_cluster.this[0].id, null)
    }
  }
}
