locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../disk"
}

# Placeholder zone_id — callers must set a real zone matching the target ECS instance.
inputs = {
  disks = {
    data-1 = {
      disk_name         = "${local.project}-${local.env}-data-1"
      zone_id           = "cn-hangzhou-h"
      size              = 40
      category          = "cloud_essd"
      performance_level = "PL0"
      encrypted         = true
    }
  }
  attachments                = {}
  snapshot_policies          = {}
  snapshot_policy_attachments = {}
}
