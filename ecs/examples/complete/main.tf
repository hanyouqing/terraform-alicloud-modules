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

module "ecs" {
  source = "../.."

  instances   = var.instances
  project     = var.project
  environment = var.environment
  tags        = var.tags
}
