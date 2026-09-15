include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/elasticsearch.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    private_vswitch_ids = { "private-a" = "vsw-mock-private-a" }
    vpc_cidr_block      = "10.0.0.0/16"
  }
}

inputs = {
  default_private_whitelist = [dependency.vpc.outputs.vpc_cidr_block]

  instances = {
    search = {
      version                  = get_env("TF_VAR_es_version", "7.10_with_X-Pack")
      vswitch_id               = dependency.vpc.outputs.private_vswitch_ids["private-a"]
      password                 = get_env("TF_VAR_es_password", "CHANGE_ME_Es8chars!")
      description              = "alicloud-modules-complete-es"
      instance_charge_type     = "PostPaid"
      data_node_amount         = 2
      data_node_spec           = get_env("TF_VAR_es_data_node_spec", "elasticsearch.sn2ne.large")
      data_node_disk_size      = 20
      data_node_disk_type      = "cloud_ssd"
      data_node_disk_encrypted = true
      enable_public            = false
      zone_count               = 2
    }
  }
}
