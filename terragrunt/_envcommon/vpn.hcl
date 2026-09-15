locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../vpn"
}

# Leaf units supply vpc_id / vswitch_id from the vpc dependency when deploying VPN.
inputs = {
  vpn_gateway_name = "${local.project}-${local.env}-vpn"
  bandwidth        = 10
  enable_ipsec     = true
  enable_ssl       = false
  network_type     = "public"
  payment_type     = "PayAsYouGo"
  customer_gateways = {}
  connections       = {}
}
