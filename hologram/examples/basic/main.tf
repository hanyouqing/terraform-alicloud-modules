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

module "hologram" {
  source = "../../"

  instances = {
    demo = {
      instance_type = var.instance_type
      payment_type  = "PostPaid"
      zone_id       = var.zone_id
      cpu           = var.cpu
    }
  }

  project     = "demo"
  environment = "development"
}
