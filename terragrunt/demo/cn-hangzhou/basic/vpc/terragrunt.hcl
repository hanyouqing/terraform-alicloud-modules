include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vpc.hcl"
  expose         = true
  # Shallow so leaf public/private_vswitches replace multi-AZ envcommon maps entirely.
  merge_strategy = "shallow"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  zone_a   = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
}

# Minimal greenfield: single AZ, no NAT (cheaper). Set real zone before apply.
inputs = {
  create_nat_gateway          = false
  create_private_route_tables = false

  public_vswitches = {
    public-a = {
      zone_id      = local.zone_a
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "${local.project}-${local.env}-public-a"
    }
  }

  private_vswitches = {
    private-a = {
      zone_id      = local.zone_a
      cidr_block   = "10.0.11.0/24"
      vswitch_name = "${local.project}-${local.env}-private-a"
    }
  }
}
