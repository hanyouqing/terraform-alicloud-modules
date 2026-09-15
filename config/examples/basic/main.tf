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

module "config" {
  source = "../.."

  create_configuration_recorder = true
  enterprise_edition            = false

  rules = {
    ecs-instance-deletion-protection = {
      source_identifier         = "ecs-instance-deletion-protection"
      source_owner              = "ALIYUN"
      risk_level                = 2
      description               = "ECS instances should have deletion protection enabled"
      config_rule_trigger_types = "ConfigurationItemChangeNotification"
      resource_types_scope      = ["ACS::ECS::Instance"]
    }
  }

  project     = "alicloud-modules"
  environment = "development"
}
