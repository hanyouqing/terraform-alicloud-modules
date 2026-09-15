variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "oss_bucket_name" {
  type        = string
  description = "Existing OSS bucket for the primary audit trail"
}

variable "oss_key_prefix" {
  type        = string
  description = "Optional OSS key prefix"
  default     = "actiontrail/"
}

variable "oss_write_role_arn" {
  type        = string
  description = "Optional RAM role ARN for OSS delivery"
  default     = null
}

variable "sls_project_arn" {
  type        = string
  description = "SLS project ARN for the secondary trail (acs:log:region:account:project/name)"
}

variable "sls_write_role_arn" {
  type        = string
  description = "RAM role ARN for SLS delivery"
  default     = null
}

variable "is_organization_trail" {
  type        = bool
  description = "Create the OSS trail as a multi-account organization trail (management account)"
  default     = false
}
