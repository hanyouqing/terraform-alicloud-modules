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

  instance_name   = var.instance_name
  deploy_type     = 5
  vpc_id          = var.vpc_id
  vswitch_ids     = var.vswitch_ids
  security_group  = var.security_group
  kms_key_id      = var.kms_key_id
  disk_type       = 1
  disk_size       = var.disk_size
  partition_num   = var.partition_num
  paid_type       = "PostPaid"
  spec_type       = var.spec_type
  service_version = var.service_version

  topics          = var.topics
  consumer_groups = var.consumer_groups
  sasl_users      = var.sasl_users

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
