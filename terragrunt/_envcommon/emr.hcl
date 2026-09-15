locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../emr"
}

# EMR is expensive — leaf unit is opt-in. Wire VPC/SG/keypair/ram_role before apply.
inputs = {
  create_cluster      = false
  cluster_name        = "${local.project}-${local.env}-emr"
  cluster_type        = "DATALAKE"
  release_version     = "EMR-5.10.0"
  payment_type        = "PostPaid"
  deletion_protection = true
  applications        = ["SPARK", "HIVE", "HDFS", "YARN"]
  node_attributes     = []
  node_groups         = []
}
