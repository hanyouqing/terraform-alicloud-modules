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

locals {
  instances = {
    primary = {
      engine                   = "MySQL"
      engine_version           = "8.0"
      instance_type            = var.instance_type
      instance_storage         = var.instance_storage
      instance_name            = "${var.project}-${var.environment}-mysql"
      vswitch_id               = var.vswitch_id
      zone_id                  = var.zone_id
      zone_id_slave_a          = var.zone_id_slave_a
      category                 = "HighAvailability"
      instance_charge_type     = "Postpaid"
      db_instance_storage_type = "cloud_essd"
      ssl_action               = "Open"
      deletion_protection      = true
      security_ips             = var.default_security_ips
      backup = {
        preferred_backup_period     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        preferred_backup_time       = "02:00Z-03:00Z"
        backup_retention_period     = 14
        enable_backup_log           = true
        log_backup_retention_period = 14
      }
    }
  }

  accounts = {
    app = {
      instance_key        = "primary"
      account_name        = var.account_name
      account_password    = var.account_password
      account_type        = "Normal"
      account_description = "application user"
    }
  }
}

module "rds" {
  source = "../../"

  default_security_ips = var.default_security_ips
  instances            = local.instances
  accounts             = local.accounts

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
