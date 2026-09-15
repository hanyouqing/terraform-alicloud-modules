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

module "cr" {
  source = "../.."

  create_ee_instance = false

  namespaces = {
    (var.namespace_name) = {
      auto_create        = false
      default_visibility = "PRIVATE"
    }
  }

  repos = {
    (var.repo_name) = {
      namespace_key = var.namespace_name
      summary       = "Basic example repository"
      repo_type     = "PRIVATE"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
