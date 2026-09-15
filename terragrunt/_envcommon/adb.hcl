locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../adb"
}

# Leaf units wire vpc_id / vswitch_id / zone_id / security_ips via dependency "vpc".
inputs = {
  clusters = {}
  accounts = {}
}
