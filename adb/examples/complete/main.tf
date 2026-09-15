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

  default_security_ips = var.default_security_ips
  clusters             = var.clusters
  accounts             = var.accounts

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
