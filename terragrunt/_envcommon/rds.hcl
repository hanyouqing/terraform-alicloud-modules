locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../rds"
}

# Leaf units set vswitch_id / zone_id from the vpc dependency.
# Override instance_type for the target region before apply.
inputs = {
  default_security_ips = ["10.0.0.0/16"]
  instances            = {}
  accounts             = {}
}
