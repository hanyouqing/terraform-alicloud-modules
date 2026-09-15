variable "create_configuration_recorder" {
  type        = bool
  description = "Create/configure the Cloud Config configuration recorder (single-account). Cloud Config is available in cn-shanghai and ap-southeast-1."
  default     = true
}

variable "enterprise_edition" {
  type        = bool
  description = "Use enterprise edition recorder. For multi-account LZ prefer an aggregator instead."
  default     = false
}

variable "recorder_resource_types" {
  type        = list(string)
  description = "Resource types monitored by the configuration recorder. Empty uses provider/service defaults where supported."
  default     = []
}

variable "rules" {
  type = map(object({
    rule_name                   = optional(string, null)
    source_identifier           = string
    source_owner                = optional(string, "ALIYUN")
    risk_level                  = optional(number, 2)
    description                 = optional(string, null)
    config_rule_trigger_types   = optional(string, "ConfigurationItemChangeNotification")
    resource_types_scope        = optional(list(string), [])
    maximum_execution_frequency = optional(string, null)
    region_ids_scope            = optional(string, null)
    resource_group_ids_scope    = optional(string, null)
    exclude_resource_ids_scope  = optional(string, null)
    tag_key_scope               = optional(string, null)
    tag_value_scope             = optional(string, null)
    input_parameters            = optional(map(string), {})
    status                      = optional(string, null)
  }))
  description = "Map of single-account Cloud Config rules (for_each). Keys are stable identifiers; rule_name defaults to the map key."
  default     = {}
}

variable "create_compliance_pack" {
  type        = bool
  description = "Create a compliance pack from selected rule keys"
  default     = false
}

variable "compliance_pack_name" {
  type        = string
  description = "Compliance pack name"
  default     = "baseline-compliance-pack"
}

variable "compliance_pack_description" {
  type        = string
  description = "Compliance pack description"
  default     = "Managed by Terraform"
}

variable "compliance_pack_risk_level" {
  type        = number
  description = "Compliance pack risk level: 1 critical, 2 warning, 3 info"
  default     = 2

  validation {
    condition     = contains([1, 2, 3], var.compliance_pack_risk_level)
    error_message = "compliance_pack_risk_level must be 1, 2, or 3."
  }
}

variable "compliance_pack_template_id" {
  type        = string
  description = "Optional compliance pack template ID"
  default     = null
}

variable "compliance_pack_rule_keys" {
  type        = list(string)
  description = "Keys from var.rules to include in the compliance pack. Empty includes all rules."
  default     = []
}

variable "create_aggregator" {
  type        = bool
  description = "Create a multi-account Cloud Config aggregator (management/delegated admin). Documented for Landing Zone use."
  default     = false
}

variable "aggregator_name" {
  type        = string
  description = "Aggregator name"
  default     = "rd-aggregator"
}

variable "aggregator_description" {
  type        = string
  description = "Aggregator description"
  default     = "Resource Directory aggregator managed by Terraform"
}

variable "aggregator_type" {
  type        = string
  description = "Aggregator type: RD (all RD members) or CUSTOM"
  default     = "RD"

  validation {
    condition     = contains(["RD", "CUSTOM"], var.aggregator_type)
    error_message = "aggregator_type must be RD or CUSTOM."
  }
}

variable "aggregator_accounts" {
  type = list(object({
    account_id   = string
    account_name = string
    account_type = optional(string, "ResourceDirectory")
  }))
  description = "Accounts for CUSTOM aggregators. Optional for RD type."
  default     = []
}

variable "aggregate_rules" {
  type = map(object({
    aggregate_config_rule_name  = optional(string, null)
    source_identifier           = string
    source_owner                = optional(string, "ALIYUN")
    risk_level                  = optional(number, 2)
    description                 = optional(string, null)
    config_rule_trigger_types   = optional(string, "ConfigurationItemChangeNotification")
    resource_types_scope        = list(string)
    maximum_execution_frequency = optional(string, null)
    region_ids_scope            = optional(string, null)
    resource_group_ids_scope    = optional(string, null)
    exclude_resource_ids_scope  = optional(string, null)
    tag_key_scope               = optional(string, null)
    tag_value_scope             = optional(string, null)
    input_parameters            = optional(map(string), {})
    status                      = optional(string, null)
  }))
  description = "Map of aggregate config rules (requires create_aggregator=true or existing_aggregator_id)"
  default     = {}
}

variable "existing_aggregator_id" {
  type        = string
  description = "Use an existing aggregator ID for aggregate_rules when create_aggregator is false"
  default     = null
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (retained for convention; Cloud Config resources may not all accept tags)"
  default     = {}
}
