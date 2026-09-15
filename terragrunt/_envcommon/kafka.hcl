locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../kafka"
}

# Leaf units wire vpc_id / vswitch_ids / security_group via dependencies.
inputs = {
  create_instance = true
  instance_name   = "${local.project}-${local.env}-kafka"
  deploy_type     = 5
  disk_type       = 1
  disk_size       = 500
  paid_type       = "PostPaid"
  spec_type       = "normal"
  service_version = "2.2.0"
  topics          = {}
  consumer_groups = {}
  sasl_users      = {}
}
