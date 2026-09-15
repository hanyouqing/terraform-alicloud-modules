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

module "pai" {
  source = "../../"

  workspace_name = var.workspace_name
  description    = "Demo PAI workspace for custom training"
  env_types      = ["prod"]

  project     = "demo"
  environment = "development"
}
