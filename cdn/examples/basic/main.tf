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

module "cdn" {
  source = "../.."

  domains = {
    www = {
      domain_name = var.domain_name
      cdn_type    = "web"
      scope       = "overseas"
      sources = [
        {
          type     = "ipaddr"
          content  = var.origin_ip
          port     = 80
          priority = 20
          weight   = 10
        }
      ]
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
