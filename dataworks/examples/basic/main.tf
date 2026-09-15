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

  display_name     = var.display_name
  project_name     = var.project_name
  pai_task_enabled = false
  description      = "demo-dataworks"

  project     = "demo"
  environment = "development"
}
