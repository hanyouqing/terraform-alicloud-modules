output "domain_ids" {
  description = "Map of Direct Mail domain IDs"
  value       = { for k, v in alicloud_direct_mail_domain.this : k => v.id }
}

output "domain_names" {
  description = "Map of Direct Mail domain names"
  value       = { for k, v in alicloud_direct_mail_domain.this : k => v.domain_name }
}

output "domain_statuses" {
  description = "Map of Direct Mail domain verification statuses"
  value       = { for k, v in alicloud_direct_mail_domain.this : k => v.status }
}

output "mail_address_ids" {
  description = "Map of mail address IDs (no secrets)"
  value       = { for k, v in alicloud_direct_mail_mail_address.this : k => v.id }
}

output "mail_addresses" {
  description = "Map of sender account names (no passwords)"
  value       = { for k, v in alicloud_direct_mail_mail_address.this : k => v.account_name }
}

output "mail_address_sendtypes" {
  description = "Map of sender send types"
  value       = { for k, v in alicloud_direct_mail_mail_address.this : k => v.sendtype }
}

output "tag_ids" {
  description = "Map of Direct Mail tag IDs"
  value       = { for k, v in alicloud_direct_mail_tag.this : k => v.id }
}

output "receiver_ids" {
  description = "Map of receivers list IDs"
  value       = { for k, v in alicloud_direct_mail_receivers.this : k => v.id }
}

output "zzz_reminders" {
  description = "SPF/DKIM and operational reminders for Direct Mail"
  value = {
    next_steps = [
      "Add DNS TXT SPF: include:spf1.dm.aliyun.com (or the exact record shown in the Direct Mail console)",
      "Add DNS CNAME/TXT DKIM records from the console verification panel for each domain",
      "Add MX record pointing to mx01.dm.aliyun.com (or console-provided value) for bounce handling",
      "Wait for domain status to become Available/Passed before high-volume sends",
      "Upload recipient lists out-of-band if using receivers resources"
    ]
    verification = [
      "Check domain status in console or via API after DNS propagation",
      "Send a test message from each mail address (batch vs trigger)",
      "Confirm reply_address mailboxes exist and accept mail"
    ]
    security_notes = [
      "Never commit SMTP passwords; pass via TF_VAR / secret store",
      "Prefer trigger sendtype for transactional mail and batch for campaigns",
      "Warm up new domains gradually to protect reputation"
    ]
    cost_optimization = [
      "Direct Mail charges per successful delivery; monitor bounce rates",
      "Remove unused sender addresses and domains"
    ]
    important_resources = {
      domain_count       = length(alicloud_direct_mail_domain.this)
      mail_address_count = length(alicloud_direct_mail_mail_address.this)
      tag_count          = length(alicloud_direct_mail_tag.this)
      receiver_count     = length(alicloud_direct_mail_receivers.this)
      project            = var.project
      environment        = var.environment
      tagging_convention = local.common_tags
    }
  }
}
