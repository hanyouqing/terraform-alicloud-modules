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

module "kafka" {
  source = "../../"

  instance_name  = "demo-kafka"
  deploy_type    = 5
  vpc_id         = var.vpc_id
  vswitch_id     = var.vswitch_id
  security_group = var.security_group
  disk_size      = 500
  paid_type      = "PostPaid"
  spec_type      = "normal"

  topics = {
    demo = {
      remark        = "basic demo topic"
      partition_num = 3
    }
  }

  project     = "demo"
  environment = "development"
}
