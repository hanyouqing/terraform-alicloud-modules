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

  domains = {
    (var.domain_name) = {}
  }

  mail_addresses = {
    noreply = {
      account_name = "noreply@${var.domain_name}"
      sendtype     = "batch"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
