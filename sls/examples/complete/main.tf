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

module "sls" {
  source = "../.."

  project_name = var.project_name
  description  = "Complete SLS example"

  log_stores = {
    access = {
      retention_period      = 90
      shard_count           = 2
      auto_split            = true
      max_split_shard_count = 64
      create_index          = true
      field_search = [
        { name = "status", type = "long" },
        { name = "method", type = "text" },
        { name = "path", type = "text" }
      ]
    }
    error = {
      retention_period = 180
      shard_count      = 2
      auto_split       = true
      create_index     = true
      full_text = {
        case_sensitive  = false
        include_chinese = false
      }
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
