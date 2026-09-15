locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../vpc"
}

# Placeholder zone_ids (cn-hangzhou-h / cn-hangzhou-i) — callers must set real zones
# for the target region before apply (aliyun ecs DescribeZones --RegionId <region>).
inputs = {
  vpc_name   = "${local.project}-${local.env}-vpc"
  cidr_block = "10.0.0.0/16"

  public_vswitches = {
    public-a = {
      zone_id      = "cn-hangzhou-h"
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "${local.project}-${local.env}-public-a"
    }
    public-b = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.2.0/24"
      vswitch_name = "${local.project}-${local.env}-public-b"
    }
  }

  private_vswitches = {
    private-a = {
      zone_id      = "cn-hangzhou-h"
      cidr_block   = "10.0.11.0/24"
      vswitch_name = "${local.project}-${local.env}-private-a"
    }
    private-b = {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.12.0/24"
      vswitch_name = "${local.project}-${local.env}-private-b"
    }
  }

  create_nat_gateway          = true
  nat_gateway_name            = "${local.project}-${local.env}-nat"
  nat_gateway_specification   = "Small"
  create_private_route_tables = true
  enable_flow_log             = false
}
