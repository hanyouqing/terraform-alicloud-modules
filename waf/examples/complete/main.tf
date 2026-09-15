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

module "waf" {
  source = "../.."

  create_instance = false
  instance_id     = var.instance_id

  domains = {
    www = {
      domain = var.www_domain
      listen = {
        http_ports    = [80]
        https_ports   = [443]
        cert_id       = var.cert_id
        tls_version   = "tlsv1.2"
        enable_tlsv3  = true
        http2_enabled = true
      }
      redirect = {
        backends        = var.backends
        loadbalance     = "roundRobin"
        connect_timeout = 5
        read_timeout    = 120
        write_timeout   = 120
        keepalive       = true
        retry           = true
        sni_enabled     = true
        request_headers = [
          {
            key   = "X-From-WAF"
            value = "true"
          }
        ]
      }
    }
    api = {
      domain = var.api_domain
      listen = {
        http_ports = [80]
      }
      redirect = {
        backends    = var.backends
        loadbalance = "iphash"
      }
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
