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

module "disk" {
  source = "../../"

  disks = {
    data = {
      disk_name         = "demo-data-disk"
      zone_id           = var.zone_id
      size              = 40
      category          = "cloud_essd"
      performance_level = "PL1"
      encrypted         = true
    }
  }

  project     = "demo"
  environment = "development"
}
