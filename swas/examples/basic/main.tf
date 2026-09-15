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

module "swas" {
  source = "../.."

  instances = {
    web-1 = {
      image_id     = var.image_id
      plan_id      = var.plan_id
      payment_type = "Subscription"
      period       = var.period
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
