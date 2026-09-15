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

module "emr" {
  source = "../../"

  cluster_name        = var.cluster_name
  cluster_type        = "DATALAKE"
  release_version     = var.release_version
  payment_type        = "PayAsYouGo"
  deletion_protection = false
  applications        = var.applications
  node_attributes     = var.node_attributes
  node_groups         = var.node_groups

  project     = "demo"
  environment = "development"
}
