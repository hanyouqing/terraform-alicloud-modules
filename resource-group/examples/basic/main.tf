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

module "resource_group" {
  source = "../.."

  resource_groups = {
    app = {
      display_name = "Application"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
