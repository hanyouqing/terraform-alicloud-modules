locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../elasticsearch"
}

# Leaf units set vswitch_id / whitelist from the vpc dependency.
inputs = {
  default_private_whitelist = ["10.0.0.0/16"]
  instances                 = {}
}
