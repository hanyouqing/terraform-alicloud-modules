# Account-level configuration for the "demo" Alibaba Cloud account.
#
# This file is read by root.hcl via find_in_parent_folders("account.hcl").
# All stacks under this directory inherit these values.
#
# To add another account, create a sibling directory (e.g., ../prod/) with its own account.hcl.
# Prefer env vars / .env.sh (see repo root env.sh.example); do not hardcode secrets.

locals {
  account_name = get_env("TF_VAR_account_name", "demo")
  # Optional Alibaba Cloud account ID (placeholder via get_env).
  account_id = get_env("TF_VAR_account_id", get_env("ALICLOUD_ACCOUNT_ID", "REPLACE_ME"))
}
