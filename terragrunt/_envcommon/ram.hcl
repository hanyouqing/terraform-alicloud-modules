locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../ram"
}

# Defaults are empty; leaf units define users/roles/policies as needed.
# Prefer SSO/roles over long-lived access keys in production.
inputs = {
  users                     = {}
  roles                     = {}
  policies                  = {}
  groups                    = {}
  group_memberships         = {}
  user_policy_attachments   = {}
  role_policy_attachments   = {}
  group_policy_attachments  = {}
}
