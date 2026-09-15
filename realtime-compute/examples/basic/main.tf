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

module "realtime_compute" {
  source = "../../"

  vvp_instance_name = var.vvp_instance_name
  payment_type      = "PayAsYouGo"
  vpc_id            = var.vpc_id
  vswitch_ids       = var.vswitch_ids
  zone_id           = var.zone_id
  storage = {
    oss_bucket = var.oss_bucket
  }

  project     = "demo"
  environment = "development"
}
