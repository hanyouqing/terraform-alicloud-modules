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

  contacts = {
    primary = {
      describe               = "Primary on-call"
      channels_mail          = var.contact_mail
      channels_ding_web_hook = var.ding_webhook
    }
  }

  contact_groups = {
    ops = {
      describe = "Operations on-call group"
      contacts = ["primary"]
    }
  }

  alarms = {
    ecs-cpu = {
      project             = "acs_ecs_dashboard"
      metric              = "CPUUtilization"
      contact_groups      = ["ops"]
      period              = 60
      silence_time        = 3600
      webhook             = var.alarm_webhook
      statistics          = "Average"
      comparison_operator = ">="
      threshold           = "85"
      times               = 3
      dimensions = [{
        instanceId = var.instance_id
      }]
      warn = {
        statistics          = "Average"
        comparison_operator = ">="
        threshold           = "70"
        times               = 3
      }
    }
  }

  site_monitors = {
    homepage = {
      address   = var.site_monitor_address
      task_type = "HTTP"
      interval  = 5
    }
  }

  monitor_group = {
    monitor_group_name = "complete-app-group"
    contact_groups     = ["ops"]
  }

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
