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

module "fcv3" {
  source = "../../"

  functions = {
    hello = {
      handler     = var.handler
      runtime     = var.runtime
      description = "demo-fcv3"
      timeout     = 30
      memory_size = 128
      code = (var.oss_bucket_name != null || var.zip_file != null) ? {
        oss_bucket_name = var.oss_bucket_name
        oss_object_name = var.oss_object_name
        zip_file        = var.zip_file
      } : null
    }
  }

  project     = "demo"
  environment = "development"
}
