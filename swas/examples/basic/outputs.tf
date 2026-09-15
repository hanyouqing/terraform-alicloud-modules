output "instance_ids" {
  description = "SWAS instance IDs"
  value       = module.swas.instance_ids
}

output "public_ips" {
  description = "Public IPs when available"
  value       = module.swas.public_ips
}
