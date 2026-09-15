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

module "arms" {
  source = "../../"

  grafana_instance_id = var.grafana_instance_id

  prometheus = {
    demo = {
      cluster_type = "remote-write"
      cluster_name = "demo-rw"
    }
  }

  project     = "demo"
  environment = "development"
}
