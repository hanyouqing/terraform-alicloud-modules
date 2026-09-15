variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "bucket_name" {
  type        = string
  description = "OSS bucket name referenced by the sample policy"
  default     = "example-bucket"
}

variable "create_access_key" {
  type        = bool
  description = "Whether to create an access key for the deployer user (avoid in production)"
  default     = false
}

variable "account_id" {
  type        = string
  description = "Alibaba Cloud account ID (required to wire SAML/OIDC federated role trust ARNs)"
  default     = null
}

variable "saml_metadata_document" {
  type        = string
  description = "Base64-encoded IdP SAML metadata XML. When set, creates a RAM SAML provider + sample federated role."
  default     = null
  sensitive   = true
}

variable "saml_provider_name" {
  type        = string
  description = "RAM SAML provider name"
  default     = "enterprise-idp"
}

variable "oidc_issuer_url" {
  type        = string
  description = "OIDC issuer URL (e.g. https://token.actions.githubusercontent.com). When set, creates an OIDC provider + sample role."
  default     = null
}

variable "oidc_provider_name" {
  type        = string
  description = "IMS OIDC provider name"
  default     = "github"
}

variable "oidc_audiences" {
  type        = list(string)
  description = "OIDC client IDs / audiences"
  default     = ["sts.aliyuncs.com"]
}

variable "oidc_fingerprints" {
  type        = list(string)
  description = "OIDC IdP certificate fingerprints"
  default     = []
}
