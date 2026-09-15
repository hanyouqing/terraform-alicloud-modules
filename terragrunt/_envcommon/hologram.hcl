locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../hologram"
}

# Leaf units wire zone_id / VPC endpoints via dependency "vpc".
inputs = {
  instances = {}
}
