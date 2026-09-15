locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../kms"
}

inputs = {
  description            = "CMK for ${local.project}-${local.env}"
  pending_window_in_days = 30
  protection_level       = "SOFTWARE"
  key_usage              = "ENCRYPT/DECRYPT"
  key_spec               = "Aliyun_AES_256"
  automatic_rotation     = "Disabled"
  status                 = "Enabled"
  create_alias           = true
  alias_name             = "alias/${local.project}-${local.env}-cmk"
  secrets                = {}
}
