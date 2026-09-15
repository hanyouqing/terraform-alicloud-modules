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

  instances      = var.instances
  firewall_rules = var.firewall_rules
  project        = var.project
  environment    = var.environment
  tags           = var.tags
}
