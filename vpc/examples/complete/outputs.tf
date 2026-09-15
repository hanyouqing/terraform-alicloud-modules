output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_vswitch_ids" {
  description = "Public vswitch IDs"
  value       = module.vpc.public_vswitch_ids
}

output "private_vswitch_ids" {
  description = "Private vswitch IDs"
  value       = module.vpc.private_vswitch_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "eip_address" {
  description = "NAT EIP address"
  value       = module.vpc.eip_address
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = module.vpc.private_route_table_ids
}

output "zzz_reminders" {
  description = "Module reminders"
  value       = module.vpc.zzz_reminders
}
