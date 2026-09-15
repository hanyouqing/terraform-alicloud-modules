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

module "sls" {
  source = "../.."

  project_name = var.project_name

  log_stores = {
    app = {
      retention_period = 30
      shard_count      = 2
      auto_split       = true
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
