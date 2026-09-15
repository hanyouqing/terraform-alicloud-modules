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

module "cdn" {
  source = "../.."

  domains = {
    web = {
      domain_name = var.web_domain_name
      cdn_type    = "web"
      scope       = var.scope
      sources = [
        {
          type     = "domain"
          content  = var.origin_domain
          port     = 80
          priority = 20
          weight   = 10
        }
      ]
      configs = {
        ip-allow = {
          function_name = "ip_allow_list_set"
          function_args = [
            {
              arg_name  = "ip_list"
              arg_value = var.ip_allow_list
            }
          ]
        }
      }
    }
    download = {
      domain_name = var.download_domain_name
      cdn_type    = "download"
      scope       = var.scope
      sources = [
        {
          type     = "oss"
          content  = var.oss_origin
          port     = 80
          priority = 20
          weight   = 10
        }
      ]
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
