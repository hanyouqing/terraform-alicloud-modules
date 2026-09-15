output "cluster_id" {
  description = "ID of the managed ACK cluster"
  value       = alicloud_cs_managed_kubernetes.this.id
}

output "cluster_name" {
  description = "Name of the managed ACK cluster"
  value       = alicloud_cs_managed_kubernetes.this.name
}

output "vpc_id" {
  description = "VPC ID of the cluster"
  value       = alicloud_cs_managed_kubernetes.this.vpc_id
}

output "connections" {
  description = "Cluster API connection endpoints (api_server_internet / api_server_intranet when present)"
  value       = try(alicloud_cs_managed_kubernetes.this.connections, null)
}

output "slb_id" {
  description = "API server load balancer ID"
  value       = try(alicloud_cs_managed_kubernetes.this.slb_id, null)
}

output "slb_internet" {
  description = "Public API server endpoint / IP when enabled"
  value       = try(alicloud_cs_managed_kubernetes.this.slb_internet, null)
}

output "slb_intranet" {
  description = "Private API server endpoint / IP"
  value       = try(alicloud_cs_managed_kubernetes.this.slb_intranet, null)
}

output "security_group_id" {
  description = "Security group ID associated with the cluster"
  value       = try(alicloud_cs_managed_kubernetes.this.security_group_id, null)
}

output "worker_ram_role_name" {
  description = "RAM role name attached to worker nodes"
  value       = try(alicloud_cs_managed_kubernetes.this.worker_ram_role_name, null)
}

output "rrsa_metadata" {
  description = "RRSA metadata when enable_rrsa is true"
  value       = try(alicloud_cs_managed_kubernetes.this.rrsa_metadata, null)
}

output "cluster_ca_cert" {
  description = "Cluster CA certificate when available (prefer alicloud_cs_cluster_credential data source for kubeconfig)"
  value       = try(alicloud_cs_managed_kubernetes.this.cluster_ca_cert, null)
  sensitive   = true
}

output "node_pool_ids" {
  description = "Map of node pool IDs"
  value       = { for k, v in alicloud_cs_kubernetes_node_pool.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the ACK module"
  value = {
    next_steps = [
      "Configure RBAC and least-privilege kubeconfig via RAM/RRSA; avoid long-lived admin kubeconfigs",
      "Prefer private API access (slb_internet_enabled=false) and reach the API via VPN/CEN/bastion",
      "Install cluster addons post-create with alicloud_cs_kubernetes_addon when needed",
      "Fetch kubeconfig with data source alicloud_cs_cluster_credential (kube_config attribute was removed from the cluster resource)",
      "Enable deletion_protection for production clusters"
    ]
    verification = [
      "Cluster ID: ${alicloud_cs_managed_kubernetes.this.id}",
      "Describe cluster: aliyun cs GET /clusters/${alicloud_cs_managed_kubernetes.this.id}",
      "Private API: ${try(alicloud_cs_managed_kubernetes.this.slb_intranet, "n/a")}",
      "Public API enabled: ${var.slb_internet_enabled}"
    ]
    security_notes = [
      "Managed ACK is preferred over dedicated alicloud_cs_kubernetes",
      "skip_set_certificate_authority defaults to true; do not export CA material to state unless required",
      "Node pool system disks default to encrypted cloud_essd",
      "new_nat_gateway defaults to false; provision NAT via the vpc module when private outbound is required",
      "Review RBAC bindings and network policies before exposing workloads"
    ]
    cost_optimization = [
      "Right-size node pool instance_types and desired_size",
      "Use scaling_config for bursty workloads instead of oversized static pools",
      "Prefer ack.pro.small unless provisioned control-plane tiers are required",
      "Disable unused public API SLB (slb_internet_enabled=false)"
    ]
    important_resources = {
      cluster_id      = alicloud_cs_managed_kubernetes.this.id
      network_plugin  = var.network_plugin
      node_pool_count = length(alicloud_cs_kubernetes_node_pool.this)
      node_pool_ids   = { for k, v in alicloud_cs_kubernetes_node_pool.this : k => v.id }
      private_api     = try(alicloud_cs_managed_kubernetes.this.slb_intranet, null)
    }
  }
}
