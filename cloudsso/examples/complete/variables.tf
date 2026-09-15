variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "create_directory" {
  type        = bool
  description = "Create a new CloudSSO directory (typically once per organization)"
  default     = false
}

variable "directory_id" {
  type        = string
  description = "Existing CloudSSO directory ID when create_directory is false"
  default     = null
}

variable "directory_name" {
  type        = string
  description = "Directory name when create_directory is true"
  default     = "tf-cloudsso"
}

variable "alice_email" {
  type        = string
  description = "Email for the sample alice user"
  default     = "alice@example.com"
}

variable "target_account_id" {
  type        = string
  description = "Resource Directory member account ID for access assignment (optional)"
  default     = null
}

variable "saml_metadata_document" {
  type        = string
  description = "Base64-encoded external IdP SAML metadata. Applied when create_directory is true."
  default     = null
  sensitive   = true
}

variable "enable_scim" {
  type        = bool
  description = "Enable SCIM sync status + a SCIM server credential (requires directory)"
  default     = false
}
