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

module "security_group" {
  source = "../.."

  security_group_name = "basic-sg"
  description         = "Basic locked-down security group"
  vpc_id              = var.vpc_id

  ingress_rules    = {}
  allow_all_egress = true

  project     = "alicloud-modules"
  environment = "development"
}
