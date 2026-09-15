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

  create_cluster      = var.create_cluster
  cluster_name        = var.cluster_name
  cluster_type        = var.cluster_type
  release_version     = var.release_version
  payment_type        = var.payment_type
  deletion_protection = var.deletion_protection
  security_mode       = var.security_mode
  applications        = var.applications
  node_attributes     = var.node_attributes
  node_groups         = var.node_groups
  application_configs = var.application_configs
  bootstrap_scripts   = var.bootstrap_scripts

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
