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

module "disk" {
  source = "../../"

  disks                       = var.disks
  attachments                 = var.attachments
  snapshot_policies           = var.snapshot_policies
  snapshot_policy_attachments = var.snapshot_policy_attachments

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
