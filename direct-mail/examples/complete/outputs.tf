output "domain_ids" {
  description = "Domain IDs"
  value       = module.direct_mail.domain_ids
}

output "domain_names" {
  description = "Domain names"
  value       = module.direct_mail.domain_names
}

output "mail_addresses" {
  description = "Sender addresses"
  value       = module.direct_mail.mail_addresses
}

output "tag_ids" {
  description = "Campaign tag IDs"
  value       = module.direct_mail.tag_ids
}

output "receiver_ids" {
  description = "Receivers list IDs"
  value       = module.direct_mail.receiver_ids
}
