include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/kafka.hcl"
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
      "private-b" = "vsw-mock-private-b"
    }
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
  vpc_id = dependency.vpc.outputs.vpc_id
  vswitch_ids = [
    dependency.vpc.outputs.private_vswitch_ids["private-a"],
    dependency.vpc.outputs.private_vswitch_ids["private-b"],
  ]
  security_group = dependency.security_group.outputs.security_group_id

  topics = {
    app-events = {
      remark        = "application events"
      partition_num = 3
    }
  }
}
