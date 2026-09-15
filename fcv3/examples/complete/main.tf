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

module "fcv3" {
  source = "../../"

  functions      = var.functions
  triggers       = var.triggers
  custom_domains = var.custom_domains

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
