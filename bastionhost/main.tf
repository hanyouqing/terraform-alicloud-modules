locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/bastionhost"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  instance_id = var.create_instance ? alicloud_bastionhost_instance.this[0].id : var.instance_id
}

resource "alicloud_bastionhost_instance" "this" {
  count = var.create_instance ? 1 : 0

  description          = var.description
  license_code         = var.license_code
  plan_code            = var.plan_code
  storage              = var.storage
  bandwidth            = var.bandwidth
  period               = var.period
  vswitch_id           = var.vswitch_id
  security_group_ids   = var.security_group_ids
  resource_group_id    = var.resource_group_id
  enable_public_access = var.enable_public_access
  public_white_list    = length(var.public_white_list) > 0 ? var.public_white_list : null
  tags                 = local.common_tags

  lifecycle {
    precondition {
      condition     = var.license_code != null && var.license_code != ""
      error_message = "create_instance requires license_code."
    }

    precondition {
      condition     = var.vswitch_id != null && var.vswitch_id != ""
      error_message = "create_instance requires vswitch_id."
    }

    precondition {
      condition     = length(var.security_group_ids) > 0
      error_message = "create_instance requires security_group_ids."
    }
  }
}

resource "alicloud_bastionhost_user_group" "this" {
  for_each = var.user_groups

  instance_id     = local.instance_id
  user_group_name = coalesce(each.value.user_group_name, each.key)
  comment         = each.value.comment
}

resource "alicloud_bastionhost_user" "this" {
  for_each = var.users

  instance_id         = local.instance_id
  user_name           = coalesce(each.value.user_name, each.key)
  display_name        = each.value.display_name
  source              = each.value.source
  password            = each.value.password
  email               = each.value.email
  mobile              = each.value.mobile
  mobile_country_code = each.value.mobile_country_code
  comment             = each.value.comment
  status              = each.value.status

  lifecycle {
    ignore_changes = [password]
  }
}

resource "alicloud_bastionhost_host" "this" {
  for_each = var.hosts

  instance_id          = local.instance_id
  host_name            = coalesce(each.value.host_name, each.key)
  active_address_type  = each.value.active_address_type
  host_private_address = each.value.host_private_address
  host_public_address  = each.value.host_public_address
  os_type              = each.value.os_type
  source               = each.value.source
  source_instance_id   = each.value.source_instance_id
  comment              = each.value.comment
}

resource "alicloud_bastionhost_host_account" "this" {
  for_each = var.host_accounts

  instance_id       = local.instance_id
  host_id           = alicloud_bastionhost_host.this[each.value.host_key].host_id
  host_account_name = coalesce(each.value.host_account_name, each.key)
  protocol_name     = each.value.protocol_name
  password          = each.value.password
  private_key       = each.value.private_key
  pass_phrase       = each.value.pass_phrase

  lifecycle {
    ignore_changes = [password, private_key, pass_phrase]
  }
}

resource "alicloud_bastionhost_user_attachment" "this" {
  for_each = var.user_attachments

  instance_id   = local.instance_id
  user_group_id = alicloud_bastionhost_user_group.this[each.value.user_group_key].user_group_id
  user_id       = alicloud_bastionhost_user.this[each.value.user_key].user_id
}

resource "alicloud_bastionhost_host_account_user_attachment" "this" {
  for_each = var.host_account_user_attachments

  instance_id      = local.instance_id
  user_id          = alicloud_bastionhost_user.this[each.value.user_key].user_id
  host_id          = alicloud_bastionhost_host.this[each.value.host_key].host_id
  host_account_ids = [alicloud_bastionhost_host_account.this[each.value.host_account_key].host_account_id]
}

resource "alicloud_bastionhost_host_account_user_group_attachment" "this" {
  for_each = var.host_account_user_group_attachments

  instance_id      = local.instance_id
  user_group_id    = alicloud_bastionhost_user_group.this[each.value.user_group_key].user_group_id
  host_id          = alicloud_bastionhost_host.this[each.value.host_key].host_id
  host_account_ids = [alicloud_bastionhost_host_account.this[each.value.host_account_key].host_account_id]
}

check "existing_instance_id" {
  assert {
    condition = (
      var.create_instance ||
      (var.instance_id != null && var.instance_id != "") ||
      (
        length(var.users) == 0 &&
        length(var.user_groups) == 0 &&
        length(var.hosts) == 0 &&
        length(var.host_accounts) == 0 &&
        length(var.user_attachments) == 0 &&
        length(var.host_account_user_attachments) == 0 &&
        length(var.host_account_user_group_attachments) == 0
      )
    )
    error_message = "When create_instance is false and users/hosts/attachments are configured, instance_id must be set."
  }
}
