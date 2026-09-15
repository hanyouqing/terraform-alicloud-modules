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

module "resource_group" {
  source = "../.."

  resource_groups = {
    network = {
      display_name        = "Network"
      resource_group_name = "rg-network"
    }
    application = {
      display_name        = "Application"
      resource_group_name = "rg-application"
      tags = {
        Tier = "app"
      }
    }
    data = {
      display_name        = "Data"
      resource_group_name = "rg-data"
      tags = {
        Tier = "data"
      }
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
