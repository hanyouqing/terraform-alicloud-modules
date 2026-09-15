include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/emr.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Optional / heavy: EMR node groups are costly. Defaults keep create_cluster=false.
# Set create_cluster=true and fill node_attributes / node_groups (keypair, ram_role) before apply.
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

dependency "security_group" {
  config_path = "../security-group"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    security_group_id = "sg-mock"
  }
}

inputs = {
  # Keep off by default — enable only when intentionally provisioning EMR.
  create_cluster      = false
  deletion_protection = true
  payment_type        = "PostPaid"
}
