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

module "realtime_compute" {
  source = "../../"

  create_vvp_instance = var.create_vvp_instance
  vvp_instance_name   = var.vvp_instance_name
  payment_type        = var.payment_type
  vpc_id              = var.vpc_id
  vswitch_ids         = var.vswitch_ids
  zone_id             = var.zone_id
  duration            = var.duration
  pricing_cycle       = var.pricing_cycle
  resource_group_id   = var.resource_group_id
  resource_spec       = var.resource_spec
  storage             = var.storage
  deployments         = var.deployments

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
