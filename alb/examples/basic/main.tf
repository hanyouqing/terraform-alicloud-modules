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

module "alb" {
  source = "../.."

  load_balancer_name = "basic-alb"
  vpc_id             = var.vpc_id
  address_type       = "Internet"
  zone_mappings      = var.zone_mappings

  server_groups = {
    default = {
      protocol = "HTTP"
      health_check = {
        health_check_enabled = true
        health_check_path    = "/"
      }
    }
  }

  listeners = {
    http = {
      listener_protocol = "HTTP"
      listener_port     = 80
      server_group_key  = "default"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
