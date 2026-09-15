output "physical_connection_id" {
  description = "Effective physical connection ID (created or supplied)"
  value       = local.physical_connection_id_effective
}

output "physical_connection_order_id" {
  description = "Order ID when a physical connection is created and Enabled"
  value       = var.create_physical_connection ? alicloud_express_connect_physical_connection.this[0].order_id : null
}

output "vbr_ids" {
  description = "Map of Virtual Border Router IDs"
  value       = { for k, v in alicloud_express_connect_virtual_border_router.this : k => v.id }
}

output "vbr_route_table_ids" {
  description = "Map of VBR route table IDs"
  value       = { for k, v in alicloud_express_connect_virtual_border_router.this : k => v.route_table_id }
}

output "router_interface_ids" {
  description = "Map of Express Connect router interface IDs"
  value       = { for k, v in alicloud_express_connect_router_interface.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for Express Connect / 高速通道"
  value = {
    next_steps = [
      "Physical lines (含跨境/海外专线接入) often require console or carrier order before Terraform can attach VBRs",
      "Create VBRs after the physical connection reaches Available / Enabled",
      "Attach VBRs to CEN (cen module) for multi-region / multi-VPC connectivity",
      "Configure on-premises BGP or static routes toward local_gateway_ip / peer_gateway_ip",
      "Router interfaces are optional legacy VBR↔VPC attachment; prefer CEN for new designs"
    ]
    verification = [
      "List physical connections: aliyun vpc DescribePhysicalConnections",
      "List VBRs: aliyun vpc DescribeVirtualBorderRouters",
      "Confirm VLAN and peering IPs match the carrier LoA"
    ]
    security_notes = [
      "Treat VBR as an untrusted edge; apply security groups and NACLs on attached VPCs",
      "Prefer BFD/BGP authentication where supported",
      "Isolate overseas / cross-border circuits from domestic traffic with separate VBRs and CEN route maps"
    ]
    cost_optimization = [
      "Physical ports and router interface bandwidth are billed while provisioned",
      "Right-size VBR and router interface specs; delete unused interfaces",
      "Cross-border circuits have higher monthly fees — validate before enabling"
    ]
    important_resources = {
      physical_connection_id     = local.physical_connection_id_effective
      vbr_count                  = length(alicloud_express_connect_virtual_border_router.this)
      router_interface_count     = length(alicloud_express_connect_router_interface.this)
      create_physical_connection = var.create_physical_connection
    }
  }
}
