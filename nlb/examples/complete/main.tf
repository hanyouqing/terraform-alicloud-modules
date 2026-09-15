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

module "nlb" {
  source = "../.."

  load_balancer_name = "complete-nlb"
  vpc_id             = var.vpc_id
  address_type       = var.address_type
  zone_mappings      = var.zone_mappings
  security_group_ids = var.security_group_ids

  server_groups = {
    app = {
      protocol                 = "TCP"
      scheduler                = "Wrr"
      connection_drain_enabled = true
      connection_drain_timeout = 60
      health_check = {
        health_check_enabled         = true
        health_check_type            = "TCP"
        health_check_interval        = 10
        health_check_connect_timeout = 5
        healthy_threshold            = 2
        unhealthy_threshold          = 2
      }
      servers = var.backend_servers
    }
  }

  listeners = merge(
    {
      tcp = {
        listener_protocol      = "TCP"
        listener_port          = 80
        server_group_key       = "app"
        proxy_protocol_enabled = false
      }
    },
    length(var.certificate_ids) > 0 ? {
      tcpssl = {
        listener_protocol = "TCPSSL"
        listener_port     = 443
        server_group_key  = "app"
        certificate_ids   = var.certificate_ids
      }
    } : {}
  )

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
