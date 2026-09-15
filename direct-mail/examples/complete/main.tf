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

module "direct_mail" {
  source = "../.."

  domains        = var.domains
  mail_addresses = var.mail_addresses
  mail_tags      = var.mail_tags
  receivers      = var.receivers

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
