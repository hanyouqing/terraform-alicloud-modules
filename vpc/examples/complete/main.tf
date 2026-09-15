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

  vpc_name              = var.vpc_name
  cidr_block            = var.cidr_block
  secondary_cidr_blocks = var.secondary_cidr_blocks
  resource_group_id     = var.resource_group_id

  public_vswitches  = var.public_vswitches
  private_vswitches = var.private_vswitches

  create_nat_gateway          = var.create_nat_gateway
  nat_gateway_name            = var.nat_gateway_name
  nat_gateway_specification   = var.nat_gateway_specification
  nat_vswitch_key             = var.nat_vswitch_key
  eip_bandwidth               = var.eip_bandwidth
  create_public_route_tables  = var.create_public_route_tables
  create_private_route_tables = var.create_private_route_tables

  enable_flow_log       = var.enable_flow_log
  flow_log_name         = var.flow_log_name
  flow_log_project      = var.flow_log_project
  flow_log_logstore     = var.flow_log_logstore
  flow_log_traffic_type = var.flow_log_traffic_type

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
