output "vpn_gateway_id" {
  description = "ID of the VPN gateway"
  value       = alicloud_vpn_gateway.this.id
}

output "internet_ip" {
  description = "Public IP of the VPN gateway"
  value       = alicloud_vpn_gateway.this.internet_ip
}

output "customer_gateway_ids" {
  description = "Map of customer gateway IDs"
  value       = { for k, v in alicloud_vpn_customer_gateway.this : k => v.id }
}

output "connection_ids" {
  description = "Map of IPsec connection IDs"
  value       = { for k, v in alicloud_vpn_connection.this : k => v.id }
}

output "connection_statuses" {
  description = "Map of IPsec connection statuses"
  value       = { for k, v in alicloud_vpn_connection.this : k => v.status }
}

output "zzz_reminders" {
  description = "Operational reminders for site-to-site VPN"
  value = {
    next_steps = [
      "Configure the on-premises CPE with internet_ip and matching IKE/IPsec parameters",
      "Advertise local and remote subnets consistently on both sides"
    ]
    security_notes = [
      "Use strong PSK (or certificates where supported) and IKEv2",
      "Prefer group14+ PFS and aes256/sha256 algorithms"
    ]
    cost_optimization = [
      "VPN gateway bandwidth is billed continuously while the gateway exists",
      "Delete unused gateways in non-production to avoid idle cost"
    ]
    important_resources = {
      vpn_gateway_id = alicloud_vpn_gateway.this.id
      internet_ip    = alicloud_vpn_gateway.this.internet_ip
      connections    = length(alicloud_vpn_connection.this)
    }
  }
}
