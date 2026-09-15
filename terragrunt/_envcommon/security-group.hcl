locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../security-group"
}

# vpc_id must be supplied by the leaf (dependency on vpc).
inputs = {
  security_group_name = "${local.project}-${local.env}-sg"
  description         = "Default SG for ${local.project}-${local.env}"
  allow_all_egress    = true
  ingress_rules       = {}
}
