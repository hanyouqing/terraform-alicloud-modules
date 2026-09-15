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

module "cloudsso" {
  source = "../.."

  create_directory = false
  directory_id     = var.directory_id

  users = {
    demo = {
      user_name    = var.user_name
      display_name = "Demo User"
      email        = var.user_email
    }
  }

  groups = {
    operators = {
      group_name  = "Operators"
      description = "Day-2 operators"
    }
  }

  group_memberships = {
    operators-demo = {
      group_key = "operators"
      user_keys = ["demo"]
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
