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

module "ram" {
  source = "../.."

  roles = {
    ecs-app = {
      description = "ECS application role"
      document = jsonencode({
        Statement = [{
          Effect    = "Allow"
          Action    = "sts:AssumeRole"
          Principal = { Service = ["ecs.aliyuncs.com"] }
        }]
        Version = "1"
      })
    }
  }

  policies = {
    oss-readonly = {
      description = "Read objects from a single bucket"
      policy_document = jsonencode({
        Statement = [{
          Effect   = "Allow"
          Action   = ["oss:GetObject", "oss:ListObjects"]
          Resource = ["acs:oss:*:*:${var.bucket_name}", "acs:oss:*:*:${var.bucket_name}/*"]
        }]
        Version = "1"
      })
    }
  }

  role_policy_attachments = {
    ecs-oss = {
      role_key   = "ecs-app"
      policy_key = "oss-readonly"
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
