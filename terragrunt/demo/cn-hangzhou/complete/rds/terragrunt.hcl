include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/rds.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    private_vswitch_ids = {
      "private-a" = "vsw-mock-private-a"
      "private-b" = "vsw-mock-private-b"
    }
    vpc_cidr_block = "10.0.0.0/16"
  }
}

inputs = {
  default_security_ips = [dependency.vpc.outputs.vpc_cidr_block]

  instances = {
    primary = {
      engine                   = "MySQL"
      engine_version           = "8.0"
      instance_type            = get_env("TF_VAR_rds_instance_type", "mysql.n2.medium.1")
      instance_storage         = 40
      instance_name            = "alicloud-modules-complete-mysql"
      vswitch_id               = dependency.vpc.outputs.private_vswitch_ids["private-a"]
      zone_id                  = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
      zone_id_slave_a          = get_env("TF_VAR_zone_id_b", "cn-hangzhou-i")
      category                 = "HighAvailability"
      instance_charge_type     = "Postpaid"
      db_instance_storage_type = "cloud_essd"
      ssl_action               = "Open"
      deletion_protection      = true
    }
  }
}
