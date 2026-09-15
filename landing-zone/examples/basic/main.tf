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

module "landing_zone" {
  source = "../.."

  create_resource_directory = var.create_resource_directory
  enable_default_structure  = true
  enable_workload_children  = true
  create_baseline_policies  = false
  member_accounts           = {}

  project     = "alicloud-modules"
  environment = "management"
}
