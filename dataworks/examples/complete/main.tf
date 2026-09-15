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

module "dataworks" {
  source = "../../"

  create_project          = var.create_project
  display_name            = var.display_name
  project_name            = var.project_name
  pai_task_enabled        = var.pai_task_enabled
  description             = var.description
  dev_environment_enabled = var.dev_environment_enabled
  dw_resource_groups      = var.dw_resource_groups
  project_members         = var.project_members

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
