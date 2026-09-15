include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/redis.hcl"
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
  default_security_ips = [dependency.vpc.outputs.vpc_cidr_block]

  instances = {
    cache = {
      db_instance_name = "alicloud-modules-complete-redis"
      vswitch_id       = dependency.vpc.outputs.private_vswitch_ids["private-a"]
      instance_class   = get_env("TF_VAR_redis_instance_class", "redis.master.small.default")
      engine_version   = "5.0"
      instance_type    = "Redis"
      password         = get_env("TF_VAR_redis_password", "CHANGE_ME_8chars")
      ssl_enable       = "Enable"
      vpc_auth_mode    = "Open"
      payment_type     = "PostPaid"
      zone_id          = get_env("TF_VAR_zone_id_a", "cn-hangzhou-h")
    }
  }
}
