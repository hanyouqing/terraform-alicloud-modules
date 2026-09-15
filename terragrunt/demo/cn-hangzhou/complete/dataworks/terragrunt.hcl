include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/dataworks.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  pai_task_enabled = false
}
