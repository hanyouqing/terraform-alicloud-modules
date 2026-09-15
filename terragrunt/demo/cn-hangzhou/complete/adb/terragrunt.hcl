include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/adb.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    vpc_id         = "vpc-mock"
    vpc_cidr_block = "10.0.0.0/16"
    private_vswitch_ids = {
      "private-a" = "vsw-mock-private-a"
    }
  }
}

inputs = {
  default_security_ips = [dependency.vpc.outputs.vpc_cidr_block]

  clusters = {
    analytics = {
      db_cluster_version     = get_env("TF_VAR_adb_cluster_version", "5.0")
      payment_type           = "PayAsYouGo"
      vpc_id                 = dependency.vpc.outputs.vpc_id
      vswitch_id             = dependency.vpc.outputs.private_vswitch_ids["private-a"]
      zone_id                = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
      db_cluster_description = "alicloud-modules-complete-adb"
      disk_encryption        = true
      enable_ssl             = true
      compute_resource       = get_env("TF_VAR_adb_compute_resource", "16ACU")
      storage_resource       = get_env("TF_VAR_adb_storage_resource", "0ACU")
    }
  }
}
