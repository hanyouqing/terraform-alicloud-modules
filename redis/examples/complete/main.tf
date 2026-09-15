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

locals {
  instances = {
    cache = {
      db_instance_name  = "${var.project}-${var.environment}-redis"
      vswitch_id        = var.vswitch_id
      instance_class    = var.instance_class
      instance_type     = "Redis"
      engine_version    = var.engine_version
      password          = var.password
      zone_id           = var.zone_id
      secondary_zone_id = var.secondary_zone_id
      payment_type      = "PostPaid"
      ssl_enable        = "Enable"
      vpc_auth_mode     = "Open"
      security_ips      = var.default_security_ips
      backup_period     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
      backup_time       = "02:00Z-03:00Z"
    }
  }
}

module "redis" {
  source = "../../"

  default_security_ips = var.default_security_ips
  instances            = local.instances

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
