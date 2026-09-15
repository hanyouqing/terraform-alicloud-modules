include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vpc.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Production-shaped: multi-AZ public+private, NAT on (from _envcommon defaults).
# Override placeholder zone_ids with real zones before apply.
inputs = {
  create_nat_gateway          = true
  create_private_route_tables = true
  enable_flow_log             = false

  public_vswitches = {
    public-a = {
      zone_id = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
    }
    public-b = {
      zone_id = get_env("TF_VAR_zone_id_b", "cn-hangzhou-i")
    }
  }

  private_vswitches = {
    private-a = {
      zone_id = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
    }
    private-b = {
      zone_id = get_env("TF_VAR_zone_id_b", "cn-hangzhou-i")
    }
  }
}
