output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_vswitch_ids" {
  description = "Public vswitch IDs"
  value       = module.vpc.public_vswitch_ids
}
