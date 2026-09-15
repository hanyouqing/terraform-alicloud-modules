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

module "waf" {
  source = "../.."

  create_instance = false
  instance_id     = var.instance_id

  domains = {
    www = {
      domain = var.domain
      listen = {
        http_ports = [80]
      }
      redirect = {
        backends    = var.backends
        loadbalance = "iphash"
      }
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
