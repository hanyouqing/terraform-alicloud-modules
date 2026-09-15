locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/direct-mail"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_direct_mail_domain" "this" {
  for_each = var.domains

  domain_name = coalesce(each.value.domain_name, each.key)
}

resource "alicloud_direct_mail_mail_address" "this" {
  for_each = var.mail_addresses

  account_name  = each.value.account_name
  sendtype      = each.value.sendtype
  reply_address = each.value.reply_address
  password      = each.value.password

  depends_on = [alicloud_direct_mail_domain.this]
}

resource "alicloud_direct_mail_tag" "this" {
  for_each = var.mail_tags

  tag_name = coalesce(each.value.tag_name, each.key)
}

resource "alicloud_direct_mail_receivers" "this" {
  for_each = var.receivers

  receivers_name  = coalesce(each.value.receivers_name, each.key)
  receivers_alias = each.value.receivers_alias
  description     = each.value.description
}
