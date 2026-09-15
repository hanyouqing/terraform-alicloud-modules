locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../realtime-compute"
}

# Leaf units wire vpc_id / vswitch_ids / zone_id via dependency "vpc".
inputs = {
  create_vvp_instance = true
  vvp_instance_name   = "${local.project}-${local.env}-vvp"
  payment_type        = "PayAsYouGo"
}
