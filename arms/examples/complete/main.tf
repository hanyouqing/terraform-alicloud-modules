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

module "arms" {
  source = "../../"

  create_grafana_workspace  = true
  grafana_workspace_name    = var.grafana_workspace_name
  grafana_workspace_edition = var.grafana_workspace_edition
  grafana_version           = var.grafana_version
  grafana_password          = var.grafana_password

  prometheus   = var.prometheus
  environments = var.environments

  alert_contacts       = var.alert_contacts
  alert_contact_groups = var.alert_contact_groups

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
