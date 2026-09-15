locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
  region  = local.region_vars.locals.region
}

terraform {
  # Module may be added by sibling work — path is stable once cicd/ exists.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../cicd"
}

inputs = {
  project     = local.project
  environment = local.env
}
