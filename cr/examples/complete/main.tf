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

module "cr" {
  source = "../.."

  create_ee_instance   = var.create_ee_instance
  ee_instance_id       = var.ee_instance_id
  ee_instance_name     = var.ee_instance_name
  ee_instance_type     = var.ee_instance_type
  ee_period            = var.ee_period
  ee_renewal_status    = var.ee_renewal_status
  ee_resource_group_id = var.ee_resource_group_id

  namespaces            = var.namespaces
  repos                 = var.repos
  endpoint_acl_policies = var.endpoint_acl_policies

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
