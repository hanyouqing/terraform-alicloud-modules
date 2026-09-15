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

module "nlb" {
  source = "../.."

  load_balancer_name = "basic-nlb"
  vpc_id             = var.vpc_id
  address_type       = "Intranet"
  zone_mappings      = var.zone_mappings

  server_groups = {
    default = {
      protocol = "TCP"
      health_check = {
        health_check_enabled = true
        health_check_type    = "TCP"
      }
    }
  }

  listeners = {
    tcp = {
      listener_protocol = "TCP"
      listener_port     = 80
      server_group_key  = "default"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
