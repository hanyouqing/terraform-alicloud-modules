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

module "vpn" {
  source = "../.."

  vpn_gateway_name = "basic-vpn"
  vpc_id           = var.vpc_id
  vswitch_id       = var.vswitch_id
  bandwidth        = 10
  enable_ipsec     = true

  customer_gateways = {
    onprem = {
      ip_address = var.customer_gateway_ip
    }
  }

  connections = {
    onprem = {
      customer_gateway_key = "onprem"
      local_subnet         = var.local_subnet
      remote_subnet        = var.remote_subnet
      ike_config = {
        psk         = var.psk
        ike_version = "ikev2"
      }
      ipsec_config = {
        ipsec_enc_alg = "aes256"
      }
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
