include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/arms.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Opt-in Grafana via TF_VAR; defaults keep create off for cheaper complete demos.
inputs = {
  create_grafana_workspace = get_env("TF_VAR_arms_create_grafana", "false") == "true"
  grafana_workspace_name   = "alicloud-modules-complete-grafana"
}
