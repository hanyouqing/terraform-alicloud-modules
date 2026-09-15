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

module "redis" {
  source = "../../"

  default_security_ips = [var.vpc_cidr]

  instances = {
    cache = {
      db_instance_name = "demo-redis"
      vswitch_id       = var.vswitch_id
      instance_class   = var.instance_class
      engine_version   = "5.0"
      instance_type    = "Redis"
      password         = var.password
      ssl_enable       = "Enable"
      vpc_auth_mode    = "Open"
      payment_type     = "PostPaid"
    }
  }

  project     = "demo"
  environment = "development"
}
