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

module "express_connect" {
  source = "../.."

  create_physical_connection      = var.create_physical_connection
  physical_connection_id          = var.physical_connection_id
  access_point_id                 = var.access_point_id
  line_operator                   = var.line_operator
  physical_connection_name        = var.physical_connection_name
  peer_location                   = var.peer_location
  port_type                       = var.port_type
  bandwidth                       = var.bandwidth
  physical_connection_description = var.physical_connection_description

  virtual_border_routers = var.virtual_border_routers
  router_interfaces      = var.router_interfaces

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
