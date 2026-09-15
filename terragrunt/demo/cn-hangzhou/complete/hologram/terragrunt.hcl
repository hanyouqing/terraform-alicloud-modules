include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/hologram.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    vpc_id = "vpc-mock"
    private_vswitch_ids = {
      "private-a" = "vsw-mock-private-a"
    }
  }
}

inputs = {
  instances = {
    warehouse = {
      instance_type = get_env("TF_VAR_hologram_instance_type", "Standard")
      payment_type  = "PostPaid"
      zone_id       = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
      cpu           = 8
      storage_size  = 100
      endpoints = [{
        type       = "VPCSingleTunnel"
        vpc_id     = dependency.vpc.outputs.vpc_id
        vswitch_id = dependency.vpc.outputs.private_vswitch_ids["private-a"]
      }]
    }
  }
}
