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

module "cen" {
  source = "../.."

  cen_instance_name = var.cen_instance_name
  description       = "basic cen"

  attachments = {
    vpc = {
      child_instance_id        = var.vpc_id
      child_instance_type      = "VPC"
      child_instance_region_id = var.region
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
