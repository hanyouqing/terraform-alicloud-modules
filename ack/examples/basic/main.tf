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

  cluster_name         = var.cluster_name
  worker_vswitch_ids   = var.worker_vswitch_ids
  network_plugin       = "flannel"
  pod_cidr             = var.pod_cidr
  service_cidr         = var.service_cidr
  new_nat_gateway      = false
  deletion_protection  = false
  slb_internet_enabled = false

  node_pools = {
    default = {
      instance_types        = var.instance_types
      vswitch_ids           = var.worker_vswitch_ids
      desired_size          = 2
      key_name              = var.key_name
      system_disk_category  = "cloud_essd"
      system_disk_encrypted = true
      install_cloud_monitor = true
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
