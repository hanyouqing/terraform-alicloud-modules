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

module "kms" {
  source = "../.."

  description            = "basic CMK"
  pending_window_in_days = 7
  protection_level       = "SOFTWARE"

  project     = "alicloud-modules"
  environment = "development"
}
