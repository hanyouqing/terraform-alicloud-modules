include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/fcv3.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Provide functions via TF_VAR / local override when deploying; empty keeps plan cheap.
inputs = {
  functions = {}
}
