include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/sls.hcl"
  expose         = true
  merge_strategy = "deep"
}

# SLS project names must be unique in the region — rename if the default is taken.
inputs = {}
