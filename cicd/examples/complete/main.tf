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

module "cicd" {
  source = "../../"

  namespaces      = var.namespaces
  repos           = var.repos
  image_pipelines = var.image_pipelines

  create_ci_role                 = var.create_ci_role
  ci_role_name                   = var.ci_role_name
  ci_assume_role_policy_document = var.ci_assume_role_policy_document
  ci_policy_document             = var.ci_policy_document
  ci_policy_name                 = var.ci_policy_name
  ci_attach_system_policies      = var.ci_attach_system_policies

  project     = var.project
  environment = var.environment
  tags        = var.tags
}
