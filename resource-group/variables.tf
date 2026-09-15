variable "resource_groups" {
  type = map(object({
    display_name        = string
    resource_group_name = optional(string, null)
    tags                = optional(map(string), {})
  }))
  description = "Map of account-scoped Resource Groups. Keys are logical names; set resource_group_name to override the API name (defaults to the map key)."
  default     = {}
}

variable "project" {
  type        = string
  description = "Project name for tagging / operational metadata"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging / operational metadata"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags merged into ManagedBy/Module/Project/Environment"
  default     = {}
}
