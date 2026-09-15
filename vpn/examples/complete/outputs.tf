output "vpn_gateway_id" {
  description = "VPN gateway ID"
  value       = module.vpn.vpn_gateway_id
}

output "internet_ip" {
  description = "VPN gateway public IP"
  value       = module.vpn.internet_ip
}

output "customer_gateway_ids" {
  description = "Customer gateway IDs"
  value       = module.vpn.customer_gateway_ids
}

output "connection_ids" {
  description = "IPsec connection IDs"
  value       = module.vpn.connection_ids
}
