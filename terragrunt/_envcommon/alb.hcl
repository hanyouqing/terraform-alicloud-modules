locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../alb"
}

# Leaf units supply vpc_id and zone_mappings ( ≥ 2 zones) from the vpc dependency.
inputs = {
  load_balancer_name   = "${local.project}-${local.env}-alb"
  address_type         = "Internet"
  load_balancer_edition = "Basic"
  server_groups = {
    default = {
      protocol = "HTTP"
      health_check = {
        health_check_enabled = true
        health_check_path    = "/"
      }
    }
  }
  listeners = {
    http = {
      listener_protocol = "HTTP"
      listener_port     = 80
      server_group_key  = "default"
    }
  }
}
