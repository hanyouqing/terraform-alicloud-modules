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

  create_physical_connection = false
  physical_connection_id     = var.physical_connection_id

  virtual_border_routers = {
    vbr-basic = {
      vlan_id                    = var.vlan_id
      local_gateway_ip           = var.local_gateway_ip
      peer_gateway_ip            = var.peer_gateway_ip
      peering_subnet_mask        = var.peering_subnet_mask
      virtual_border_router_name = "basic-vbr"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
