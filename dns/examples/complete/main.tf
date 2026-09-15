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

module "dns" {
  source = "../.."

  domains = {
    public = {
      domain_name = var.domain_name
      remark      = "Managed by terraform complete example"
    }
  }

  records = {
    apex = {
      domain_key = "public"
      rr         = "@"
      type       = "A"
      value      = var.apex_value
      ttl        = 600
    }
    www = {
      domain_key = "public"
      rr         = "www"
      type       = "CNAME"
      value      = var.domain_name
      ttl        = 300
    }
    mx = {
      domain_key = "public"
      rr         = "@"
      type       = "MX"
      value      = var.mx_value
      priority   = 10
      ttl        = 600
    }
  }

  private_zones = {
    internal = {
      zone_name = var.private_zone_name
      vpc_ids   = var.vpc_ids
      remark    = "Internal services"
    }
  }

  private_zone_records = {
    api = {
      zone_key = "internal"
      rr       = "api"
      type     = "A"
      value    = var.private_record_value
      ttl      = 60
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
