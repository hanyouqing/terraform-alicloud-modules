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

  cen_instance_name              = var.cen_instance_name
  description                    = var.description
  attachments                    = var.attachments
  create_bandwidth_package       = var.create_bandwidth_package
  bandwidth_package_name         = var.bandwidth_package_name
  bandwidth                      = var.bandwidth
  geographic_region_a_id         = var.geographic_region_a_id
  geographic_region_b_id         = var.geographic_region_b_id
  bandwidth_payment_type         = var.bandwidth_payment_type
  bandwidth_limits               = var.bandwidth_limits
  create_transit_router          = var.create_transit_router
  transit_router_name            = var.transit_router_name
  transit_router_region_id       = var.transit_router_region_id
  transit_router_vpc_attachments = var.transit_router_vpc_attachments
  project                        = var.project
  environment                    = var.environment
  tags                           = var.tags
}
