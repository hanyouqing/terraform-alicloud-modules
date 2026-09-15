include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/alb.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    vpc_id = "vpc-mock"
    public_vswitch_ids = {
      "public-a" = "vsw-mock-public-a"
      "public-b" = "vsw-mock-public-b"
    }
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  zone_mappings = [
    {
      zone_id    = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
      vswitch_id = dependency.vpc.outputs.public_vswitch_ids["public-a"]
    },
    {
      zone_id    = get_env("TF_VAR_zone_id_b", "cn-hangzhou-i")
      vswitch_id = dependency.vpc.outputs.public_vswitch_ids["public-b"]
    },
  ]
}
