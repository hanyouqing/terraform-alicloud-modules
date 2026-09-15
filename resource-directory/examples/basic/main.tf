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

module "resource_directory" {
  source = "../.."

  create_resource_directory = false

  folders = {
    development = {
      folder_name = "development"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
