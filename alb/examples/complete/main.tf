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

module "alb" {
  source = "../.."

  load_balancer_name    = "complete-alb"
  load_balancer_edition = "Standard"
  vpc_id                = var.vpc_id
  address_type          = var.address_type
  zone_mappings         = var.zone_mappings

  server_groups = {
    app = {
      protocol  = "HTTP"
      scheduler = "Wrr"
      health_check = {
        health_check_enabled  = true
        health_check_protocol = "HTTP"
        health_check_path     = "/healthz"
        health_check_method   = "GET"
        health_check_codes    = ["http_2xx", "http_3xx"]
        health_check_interval = 5
        healthy_threshold     = 3
        unhealthy_threshold   = 3
      }
      servers = var.backend_servers
    }
  }

  listeners = merge(
    {
      http = {
        listener_protocol = "HTTP"
        listener_port     = 80
        server_group_key  = "app"
      }
    },
    var.certificate_id != null ? {
      https = {
        listener_protocol = "HTTPS"
        listener_port     = 443
        server_group_key  = "app"
        certificate_id    = var.certificate_id
        http2_enabled     = true
      }
    } : {}
  )

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
