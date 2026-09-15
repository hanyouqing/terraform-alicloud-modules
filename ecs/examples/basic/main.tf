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

module "ecs" {
  source = "../.."

  instances = {
    app-1 = {
      image_id        = var.image_id
      instance_type   = var.instance_type
      vswitch_id      = var.vswitch_id
      security_groups = var.security_groups
      key_name        = var.key_name
      instance_name   = "basic-app-1"
      system_disk = {
        category  = "cloud_essd"
        size      = 40
        encrypted = true
      }
      internet_max_bandwidth_out = 0
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
