include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/cicd.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Stub until cicd module lands — no VPC dependency by default.
inputs = {}
