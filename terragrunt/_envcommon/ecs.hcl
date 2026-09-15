locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../ecs"
}

# Leaf units wire vswitch_id / security_groups via vpc (+ security-group) dependencies.
# Override image_id, instance_type, and key_name for the target region before apply.
inputs = {
  instances = {}
}
