# Environment-level configuration — enterprise production-oriented stack.
#
# This file is read by root.hcl via find_in_parent_folders("env.hcl").
# Account and region are inherited from parent account.hcl and region.hcl.

locals {
  environment = "complete"
  project     = "alicloud-modules"
}
