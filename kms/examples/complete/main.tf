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

  description            = "complete CMK"
  pending_window_in_days = 30
  protection_level       = "SOFTWARE"
  automatic_rotation     = "Enabled"
  rotation_interval      = "90d"

  create_alias = true
  alias_name   = var.alias_name

  secrets = {
    app-secret = {
      secret_data = var.app_secret
      description = "Application secret material"
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
