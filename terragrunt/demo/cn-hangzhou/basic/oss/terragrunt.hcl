include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/oss.hcl"
  expose         = true
  # Shallow so leaf buckets map replaces envcommon (no versioning for cheap basic).
  merge_strategy = "shallow"
}

# No VPC dependency. Bucket names are global — rename if the default is taken.
inputs = {
  buckets = {
    app-data = {
      name          = "alicloud-modules-basic-data"
      storage_class = "Standard"
      acl           = "private"
      versioning    = false
      sse_algorithm = "AES256"
      force_ssl     = true
    }
  }
}
