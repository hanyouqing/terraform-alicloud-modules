locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../redis"
}

# Leaf units set vswitch_id from the vpc dependency.
# Set password via TF_VAR / leaf inputs; never commit secrets.
inputs = {
  default_security_ips = ["10.0.0.0/16"]
  instances            = {}
}
