locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../arms"
}

# Leaf units opt into Grafana / Prometheus as needed.
inputs = {
  create_grafana_workspace = false
  prometheus               = {}
  environments             = {}
  alert_contacts           = {}
  alert_contact_groups     = {}
}
