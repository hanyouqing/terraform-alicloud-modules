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

module "elasticsearch" {
  source = "../../"

  default_private_whitelist = [var.vpc_cidr]

  instances = {
    search = {
      version              = var.es_version
      vswitch_id           = var.vswitch_id
      password             = var.password
      description          = "demo-es"
      instance_charge_type = "PostPaid"
      data_node_amount     = 2
      data_node_spec       = var.data_node_spec
      data_node_disk_size  = 20
      data_node_disk_type  = "cloud_ssd"
      enable_public        = false
    }
  }

  project     = "demo"
  environment = "development"
}
