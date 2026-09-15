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

module "dns" {
  source = "../.."

  domain_name = var.domain_name

  records = {
    www = {
      rr    = "www"
      type  = "A"
      value = var.record_value
      ttl   = 600
      line  = "default"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
