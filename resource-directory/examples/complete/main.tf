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

module "resource_directory" {
  source = "../.."

  create_resource_directory = var.create_resource_directory

  folders = {
    production = {
      folder_name = "production"
    }
    prod-app = {
      folder_name       = "app"
      parent_folder_key = "production"
    }
  }

  accounts = {
    prod-workload = {
      display_name        = var.member_display_name
      folder_key          = "prod-app"
      account_name_prefix = var.account_name_prefix
    }
  }

  control_policies = {
    deny-leave = {
      control_policy_name = "DenyLeaveOrganization"
      effect_scope        = "All"
      description         = "Prevent members from leaving the resource directory"
      policy_document = jsonencode({
        Version = "1"
        Statement = [{
          Effect   = "Deny"
          Action   = ["resourcemanager:LeaveResourceDirectory"]
          Resource = ["*"]
        }]
      })
    }
  }

  control_policy_attachments = {
    prod-deny-leave = {
      policy_key        = "deny-leave"
      target_folder_key = "production"
    }
  }

  delegated_administrators = var.enable_delegated_admin ? {
    cloudsso = {
      account_key       = "prod-workload"
      service_principal = "cloudsso.aliyuncs.com"
    }
  } : {}

  project     = "alicloud-modules"
  environment = "production"
  tags = {
    Example = "complete"
  }
}
