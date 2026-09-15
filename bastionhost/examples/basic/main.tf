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

module "bastionhost" {
  source = "../.."

  create_instance    = var.create_instance
  instance_id        = var.instance_id
  description        = var.description
  license_code       = var.license_code
  plan_code          = var.plan_code
  storage            = var.storage
  bandwidth          = var.bandwidth
  period             = var.period
  vswitch_id         = var.vswitch_id
  security_group_ids = var.security_group_ids

  users       = {}
  user_groups = {}
  hosts       = {}

  project     = "alicloud-modules"
  environment = "development"
}
