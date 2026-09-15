locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../sls"
}

# SLS project names must be globally unique within the region.
inputs = {
  project_name = "${local.project}-${local.env}-logs"
  description  = "SLS project for ${local.project}-${local.env}"
  log_stores = {
    app = {
      logstore_name    = "app"
      retention_period = 30
      shard_count      = 2
      auto_split       = true
    }
  }
}
