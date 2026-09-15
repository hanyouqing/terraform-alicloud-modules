output "bucket_names" {
  description = "Names of the OSS buckets"
  value       = { for k, v in alicloud_oss_bucket.this : k => v.bucket }
}

output "bucket_ids" {
  description = "IDs of the OSS buckets"
  value       = { for k, v in alicloud_oss_bucket.this : k => v.id }
}

output "extranet_endpoints" {
  description = "Public (extranet) endpoints of the OSS buckets"
  value       = { for k, v in alicloud_oss_bucket.this : k => v.extranet_endpoint }
}

output "intranet_endpoints" {
  description = "VPC (intranet) endpoints of the OSS buckets"
  value       = { for k, v in alicloud_oss_bucket.this : k => v.intranet_endpoint }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the OSS module"
  value = {
    next_steps = [
      "Verify bucket ACL remains private unless a public use case is required",
      "Confirm HTTPS-only access via the force_ssl bucket policy",
      "Test upload/download using the intranet endpoint from VPC workloads",
      "Review lifecycle rules for cost and retention compliance",
      "Wire application IAM/RAM policies to least-privilege bucket access",
    ]
    verification = [
      "aliyun oss ls",
      "aliyun oss GetBucketInfo --bucket ${length(alicloud_oss_bucket.this) > 0 ? values(alicloud_oss_bucket.this)[0].bucket : "N/A"}",
      "aliyun oss GetBucketVersioning --bucket ${length(alicloud_oss_bucket.this) > 0 ? values(alicloud_oss_bucket.this)[0].bucket : "N/A"}",
    ]
    security_notes = [
      "ACL defaults to private; public-read/write is discouraged",
      "Server-side encryption (AES256 or KMS) is always configured",
      "Versioning defaults to enabled for production-oriented recovery",
      "Public access block is enabled by default when supported",
      "Force SSL denies requests with acs:SecureTransport=false",
    ]
    cost_optimization = [
      "Use lifecycle transitions to IA/Archive for cold data",
      "Enable abort_multipart_upload cleanup to avoid orphaned parts",
      "Prefer intranet endpoints inside VPC to avoid egress charges",
      "Right-size retention and versioning for non-critical buckets",
    ]
    important_resources = {
      bucket_count         = length(alicloud_oss_bucket.this)
      versioning_enabled   = length(alicloud_oss_bucket_versioning.this)
      force_ssl_policies   = length(alicloud_oss_bucket_policy.force_ssl)
      public_access_blocks = length(alicloud_oss_bucket_public_access_block.this)
    }
  }
}
