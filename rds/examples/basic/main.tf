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

module "rds" {
  source = "../../"

  default_security_ips = [var.vpc_cidr]

  instances = {
    primary = {
      engine                   = "MySQL"
      engine_version           = "8.0"
      instance_type            = var.instance_type
      instance_storage         = 20
      instance_name            = "demo-mysql"
      vswitch_id               = var.vswitch_id
      zone_id                  = var.zone_id
      instance_charge_type     = "Postpaid"
      db_instance_storage_type = "cloud_essd"
      ssl_action               = "Open"
    }
  }

  project     = "demo"
  environment = "development"
}
