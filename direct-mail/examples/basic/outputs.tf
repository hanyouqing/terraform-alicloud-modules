output "domain_ids" {
  description = "Domain IDs"
  value       = module.direct_mail.domain_ids
}

output "mail_addresses" {
  description = "Sender addresses"
  value       = module.direct_mail.mail_addresses
}
