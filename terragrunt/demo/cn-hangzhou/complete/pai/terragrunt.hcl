include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/pai.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  env_types = ["prod"]
}
