locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/oss"
    Project     = var.project
    Environment = var.environment
  }

  buckets_with_versioning = {
    for k, v in var.buckets : k => v if v.versioning
  }

  buckets_force_ssl = {
    for k, v in var.buckets : k => v if v.force_ssl
  }

  buckets_public_block = {
    for k, v in var.buckets : k => v if v.block_public_access
  }
}

resource "alicloud_oss_bucket" "this" {
  for_each = var.buckets

  bucket          = each.value.name
  storage_class   = each.value.storage_class
  redundancy_type = each.value.redundancy_type

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rules
    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled
      prefix  = lifecycle_rule.value.prefix

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration_days != null ? [lifecycle_rule.value.expiration_days] : []
        content {
          days = expiration.value
        }
      }

      dynamic "transitions" {
        for_each = lifecycle_rule.value.transitions
        content {
          days          = transitions.value.days
          storage_class = transitions.value.storage_class
        }
      }

      dynamic "abort_multipart_upload" {
        for_each = lifecycle_rule.value.abort_multipart_days != null ? [lifecycle_rule.value.abort_multipart_days] : []
        content {
          days = abort_multipart_upload.value
        }
      }
    }
  }

  dynamic "logging" {
    for_each = each.value.logging != null ? [each.value.logging] : []
    content {
      target_bucket = logging.value.target_bucket
      target_prefix = logging.value.target_prefix
    }
  }

  tags = merge(local.module_tags, var.tags, each.value.tags)

  lifecycle {
    ignore_changes = [
      versioning,
      server_side_encryption_rule,
      policy,
    ]
  }
}

resource "alicloud_oss_bucket_acl" "this" {
  for_each = var.buckets

  bucket = alicloud_oss_bucket.this[each.key].bucket
  acl    = each.value.acl
}

resource "alicloud_oss_bucket_versioning" "this" {
  for_each = local.buckets_with_versioning

  bucket = alicloud_oss_bucket.this[each.key].bucket
  status = "Enabled"
}

resource "alicloud_oss_bucket_server_side_encryption" "this" {
  for_each = var.buckets

  bucket            = alicloud_oss_bucket.this[each.key].bucket
  sse_algorithm     = each.value.sse_algorithm
  kms_master_key_id = each.value.sse_algorithm == "KMS" ? each.value.kms_master_key_id : null
}

resource "alicloud_oss_bucket_policy" "force_ssl" {
  for_each = local.buckets_force_ssl

  bucket = alicloud_oss_bucket.this[each.key].bucket
  policy = jsonencode({
    Version = "1"
    Statement = [
      {
        Effect    = "Deny"
        Principal = ["*"]
        Action    = ["oss:*"]
        Resource = [
          "acs:oss:*:*:${each.value.name}",
          "acs:oss:*:*:${each.value.name}/*",
        ]
        Condition = {
          Bool = {
            "acs:SecureTransport" = ["false"]
          }
        }
      }
    ]
  })
}

resource "alicloud_oss_bucket_public_access_block" "this" {
  for_each = local.buckets_public_block

  bucket              = alicloud_oss_bucket.this[each.key].bucket
  block_public_access = true
}
