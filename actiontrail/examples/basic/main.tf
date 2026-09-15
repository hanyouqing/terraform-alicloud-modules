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

module "actiontrail" {
  source = "../.."

  trails = {
    audit-oss = {
      trail_name         = "audit-oss-basic"
      oss_bucket_name    = var.oss_bucket_name
      oss_write_role_arn = var.oss_write_role_arn
      event_rw           = "All"
      status             = "Enable"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
