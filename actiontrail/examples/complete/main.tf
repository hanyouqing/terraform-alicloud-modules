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
      trail_name            = "audit-oss-complete"
      oss_bucket_name       = var.oss_bucket_name
      oss_key_prefix        = var.oss_key_prefix
      oss_write_role_arn    = var.oss_write_role_arn
      event_rw              = "All"
      status                = "Enable"
      is_organization_trail = var.is_organization_trail
    }
    audit-sls = {
      trail_name         = "audit-sls-complete"
      sls_project_arn    = var.sls_project_arn
      sls_write_role_arn = var.sls_write_role_arn
      event_rw           = "Write"
      status             = "Enable"
    }
  }

  project     = "alicloud-modules"
  environment = "production"
}
