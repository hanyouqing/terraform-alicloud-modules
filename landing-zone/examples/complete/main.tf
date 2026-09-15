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

module "landing_zone" {
  source = "../.."

  create_resource_directory = var.create_resource_directory
  enable_default_structure  = true
  enable_workload_children  = true

  folder_names = {
    core           = "Core"
    infrastructure = "Infrastructure"
    security       = "Security"
    workloads      = "Workloads"
    production     = "Production"
    non_production = "NonProduction"
  }

  create_baseline_policies       = true
  enable_deny_leave_organization = true
  enable_protect_rd_access_role  = true
  baseline_attach_folder_keys    = ["core", "security", "workloads"]

  # Placeholder display names — replace before apply in a real org
  member_accounts = {
    log = {
      display_name = "lz-log-placeholder"
      folder_key   = "core"
    }
    security = {
      display_name = "lz-security-placeholder"
      folder_key   = "security"
    }
    shared = {
      display_name = "lz-shared-placeholder"
      folder_key   = "infrastructure"
    }
    prod_app = {
      display_name = "lz-prod-app-placeholder"
      folder_key   = "workloads_production"
    }
    nonprod_app = {
      display_name = "lz-nonprod-app-placeholder"
      folder_key   = "workloads_non_production"
    }
  }

  project     = "alicloud-modules"
  environment = "management"
}
