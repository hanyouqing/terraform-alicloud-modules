include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/ecs.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    # Public vSwitch: basic stack has no NAT, so demo instance uses public + small EIP bandwidth.
    public_vswitch_ids = { "public-a" = "vsw-mock-public-a" }
  }
}

dependency "security_group" {
  config_path = "../security-group"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    security_group_id = "sg-mock"
  }
}

inputs = {
  instances = {
    app-1 = {
      image_id                   = get_env("TF_VAR_ecs_image_id", "ubuntu_22_04_x64_20G_alibase_20240508.vhd")
      instance_type              = get_env("TF_VAR_ecs_instance_type", "ecs.t6-c1m1.large")
      vswitch_id                 = dependency.vpc.outputs.public_vswitch_ids["public-a"]
      security_groups            = [dependency.security_group.outputs.security_group_id]
      instance_name              = "alicloud-modules-basic-app-1"
      key_name                   = get_env("TF_VAR_ecs_key_name", "REPLACE_ME")
      internet_max_bandwidth_out = 1
      system_disk = {
        category          = "cloud_essd"
        size              = 40
        encrypted         = false
        performance_level = "PL0"
      }
    }
  }
}
