locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project
}

terraform {
  # Prefer local workspace path while developing; pin a git ref for published stacks.
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../oss"
}

# Create the remote-state OSS bucket once out-of-band (see terragrunt/README.md), then
# optionally manage it here after import. Bucket names are global; adjust if taken.
inputs = {
  buckets = {
    app-data = {
      name          = "${local.project}-${local.env}-data"
      storage_class = "Standard"
      acl           = "private"
      versioning    = true
      sse_algorithm = "AES256"
      force_ssl     = true
    }
  }
}
