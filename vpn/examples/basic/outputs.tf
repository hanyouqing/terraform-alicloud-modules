output "vpn_gateway_id" {
  description = "VPN gateway ID"
  value       = module.vpn.vpn_gateway_id
}

output "internet_ip" {
  description = "VPN gateway public IP"
  value       = module.vpn.internet_ip
}

output "connection_ids" {
  description = "IPsec connection IDs"
  value       = module.vpn.connection_ids
}
