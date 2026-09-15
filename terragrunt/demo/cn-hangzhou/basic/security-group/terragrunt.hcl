include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/security-group.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    vpc_id = "vpc-mock"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = {
    ssh = {
      ip_protocol = "tcp"
      port_range  = "22/22"
      cidr_ip     = get_env("TF_VAR_ssh_cidr", "10.0.0.0/16")
      description = "SSH from VPC CIDR"
    }
  }
}
