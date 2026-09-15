output "physical_connection_id" {
  description = "Physical connection ID"
  value       = module.express_connect.physical_connection_id
}

output "vbr_ids" {
  description = "VBR IDs"
  value       = module.express_connect.vbr_ids
}

output "vbr_route_table_ids" {
  description = "VBR route table IDs"
  value       = module.express_connect.vbr_route_table_ids
}

output "router_interface_ids" {
  description = "Router interface IDs"
  value       = module.express_connect.router_interface_ids
}
