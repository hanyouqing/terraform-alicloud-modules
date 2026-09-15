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

module "ack" {
  source = "../.."

  cluster_name                 = var.cluster_name
  kubernetes_version           = var.kubernetes_version
  cluster_spec                 = var.cluster_spec
  worker_vswitch_ids           = var.worker_vswitch_ids
  network_plugin               = "terway"
  pod_vswitch_ids              = var.pod_vswitch_ids
  service_cidr                 = var.service_cidr
  new_nat_gateway              = false
  deletion_protection          = var.deletion_protection
  slb_internet_enabled         = false
  enable_rrsa                  = true
  is_enterprise_security_group = true
  resource_group_id            = var.resource_group_id

  addons = [
    {
      name = "csi-plugin"
    },
    {
      name = "csi-provisioner"
    }
  ]

  node_pools  = var.node_pools
  project     = var.project
  environment = var.environment
  tags        = var.tags
}
