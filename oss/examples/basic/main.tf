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

module "oss" {
  source = "../../"

  buckets = {
    app = {
      name          = var.bucket_name
      storage_class = "Standard"
      acl           = "private"
      versioning    = true
      sse_algorithm = "AES256"
      force_ssl     = true
    }
  }

  project     = "demo"
  environment = "development"
}
