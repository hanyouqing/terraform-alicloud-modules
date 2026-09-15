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

module "cms" {
  source = "../.."

  contact_groups = {
    ops = {
      describe = "Basic ops contact group"
      contacts = var.existing_contact_names
    }
  }

  alarms = {
    ecs-cpu = {
      name                = "basic-ecs-cpu"
      project             = "acs_ecs_dashboard"
      metric              = "CPUUtilization"
      contact_groups      = ["ops"]
      period              = 300
      silence_time        = 86400
      statistics          = "Average"
      comparison_operator = ">="
      threshold           = "80"
      times               = 3
      dimensions = [{
        instanceId = var.instance_id
      }]
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
