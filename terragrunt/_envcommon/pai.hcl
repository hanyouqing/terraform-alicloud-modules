locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../pai"
}

inputs = {
  workspace_name = "${local.project}-${local.env}-pai"
  description    = "${local.project} ${local.env} PAI workspace"
  env_types      = ["prod"]
  datasets       = {}
  models         = {}
}
