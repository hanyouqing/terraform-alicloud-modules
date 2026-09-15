locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../dataworks"
}

inputs = {
  display_name     = "${local.project}-${local.env}"
  project_name     = replace("${local.project}_${local.env}_dw", "-", "_")
  pai_task_enabled = false
  description      = "${local.project} ${local.env} DataWorks"
}
