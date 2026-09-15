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
      risk_level                = 1
      config_rule_trigger_types = "ConfigurationItemChangeNotification"
      resource_types_scope      = ["ACS::ECS::Instance"]
    }
    oss-bucket-public-read-prohibited = {
      source_identifier         = "oss-bucket-public-read-prohibited"
      source_owner              = "ALIYUN"
      risk_level                = 1
      config_rule_trigger_types = "ConfigurationItemChangeNotification"
      resource_types_scope      = ["ACS::OSS::Bucket"]
    }
  }

  create_compliance_pack      = true
  compliance_pack_name        = "lz-baseline-pack"
  compliance_pack_description = "Baseline compliance pack"
  compliance_pack_risk_level  = 1
  compliance_pack_rule_keys   = []

  create_aggregator      = var.create_aggregator
  aggregator_name        = "rd-aggregator"
  aggregator_description = "Resource Directory aggregator for Landing Zone"
  aggregator_type        = "RD"
  aggregate_rules = var.create_aggregator ? {
    ecs-instance-deletion-protection = {
      source_identifier         = "ecs-instance-deletion-protection"
      source_owner              = "ALIYUN"
      risk_level                = 1
      config_rule_trigger_types = "ConfigurationItemChangeNotification"
      resource_types_scope      = ["ACS::ECS::Instance"]
    }
  } : {}

  project     = "alicloud-modules"
  environment = "production"
}
