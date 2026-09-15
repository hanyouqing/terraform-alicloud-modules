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

module "vpc" {
  source = "../.."

  vpc_name   = "basic-vpc"
  cidr_block = "10.0.0.0/16"

  public_vswitches = {
    public-a = {
      zone_id      = var.zone_id
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "public-a"
    }
  }

  private_vswitches  = {}
  create_nat_gateway = false
  enable_flow_log    = false

  project     = "alicloud-modules"
  environment = "development"
}
