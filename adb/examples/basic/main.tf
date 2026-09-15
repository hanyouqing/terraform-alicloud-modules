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

module "adb" {
  source = "../../"

  default_security_ips = [var.vpc_cidr]

  clusters = {
    analytics = {
      db_cluster_version     = var.db_cluster_version
      payment_type           = "PayAsYouGo"
      vpc_id                 = var.vpc_id
      vswitch_id             = var.vswitch_id
      zone_id                = var.zone_id
      db_cluster_description = "demo-adb-lake"
      disk_encryption        = true
      enable_ssl             = true
      compute_resource       = var.compute_resource
      storage_resource       = var.storage_resource
    }
  }

  project     = "demo"
  environment = "development"
}
