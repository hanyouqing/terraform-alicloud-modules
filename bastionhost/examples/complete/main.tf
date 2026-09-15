terraform {
  required_version = ">= 1.14.2"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.292"
    }
  }
}

provider "alicloud" {
  region = var.region
}

module "bastionhost" {
  source = "../.."

  create_instance      = var.create_instance
  instance_id          = var.instance_id
  description          = var.description
  license_code         = var.license_code
  plan_code            = var.plan_code
  storage              = var.storage
  bandwidth            = var.bandwidth
  period               = var.period
  vswitch_id           = var.vswitch_id
  security_group_ids   = var.security_group_ids
  enable_public_access = false

  users                               = var.users
  user_groups                         = var.user_groups
  hosts                               = var.hosts
  host_accounts                       = var.host_accounts
  user_attachments                    = var.user_attachments
  host_account_user_attachments       = var.host_account_user_attachments
  host_account_user_group_attachments = var.host_account_user_group_attachments

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
