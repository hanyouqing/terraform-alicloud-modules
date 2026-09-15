locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../maxcompute"
}

inputs = {
  projects = {
    "${replace("${local.project}_${local.env}_mc", "-", "_")}" = {
      comment = "${local.project} ${local.env} MaxCompute"
    }
  }
}
