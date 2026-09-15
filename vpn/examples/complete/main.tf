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

  vpn_gateway_name = "complete-vpn"
  vpc_id           = var.vpc_id
  vswitch_id       = var.vswitch_id
  bandwidth        = var.bandwidth
  enable_ipsec     = true
  network_type     = "public"
  auto_propagate   = true

  customer_gateways = {
    hq = {
      name       = "hq-cgw"
      ip_address = var.hq_customer_gateway_ip
      asn        = var.hq_asn
    }
    dr = {
      name       = "dr-cgw"
      ip_address = var.dr_customer_gateway_ip
    }
  }

  connections = {
    hq = {
      customer_gateway_key = "hq"
      local_subnet         = var.local_subnet
      remote_subnet        = var.hq_remote_subnet
      enable_dpd           = true
      enable_nat_traversal = true
      ike_config = {
        psk          = var.hq_psk
        ike_version  = "ikev2"
        ike_mode     = "main"
        ike_enc_alg  = "aes256"
        ike_auth_alg = "sha256"
        ike_pfs      = "group14"
        ike_lifetime = 86400
      }
      ipsec_config = {
        ipsec_enc_alg  = "aes256"
        ipsec_auth_alg = "sha256"
        ipsec_pfs      = "group14"
        ipsec_lifetime = 86400
      }
    }
    dr = {
      customer_gateway_key = "dr"
      local_subnet         = var.local_subnet
      remote_subnet        = var.dr_remote_subnet
      ike_config = {
        psk         = var.dr_psk
        ike_version = "ikev2"
        ike_enc_alg = "aes256"
      }
      ipsec_config = {
        ipsec_enc_alg = "aes256"
      }
    }
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
