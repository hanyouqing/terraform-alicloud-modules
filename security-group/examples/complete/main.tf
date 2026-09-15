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

  security_group_name = var.security_group_name
  description         = var.description
  vpc_id              = var.vpc_id
  security_group_type = var.security_group_type
  resource_group_id   = var.resource_group_id

  ingress_rules    = var.ingress_rules
  egress_rules     = var.egress_rules
  allow_all_egress = var.allow_all_egress

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
