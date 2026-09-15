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

module "pai" {
  source = "../../"

  workspace_name    = var.workspace_name
  description       = var.description
  env_types         = var.env_types
  display_name      = var.display_name
  resource_group_id = var.resource_group_id
  datasets          = var.datasets
  models            = var.models
  services          = var.services

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
