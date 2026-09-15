include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/oss.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Production-shaped: versioning + SSE + force_ssl (from _envcommon).
# Bucket names are global — rename if the default is taken.
inputs = {}
