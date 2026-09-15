variable "create_grafana_workspace" {
  type        = bool
  description = "Whether to create an ARMS Grafana workspace"
  default     = false
}

variable "grafana_workspace_name" {
  type        = string
  description = "Grafana workspace name (required when create_grafana_workspace is true)"
  default     = null
}

variable "grafana_workspace_edition" {
  type        = string
  description = "Grafana workspace edition (e.g. standard)"
  default     = "standard"
}

variable "grafana_version" {
  type        = string
  description = "Grafana version"
  default     = null
}

variable "grafana_description" {
  type        = string
  description = "Grafana workspace description"
  default     = null
}

variable "grafana_password" {
  type        = string
  description = "Optional Grafana admin password"
  default     = null
  sensitive   = true
}

variable "grafana_resource_group_id" {
  type        = string
  description = "Resource group for Grafana workspace"
  default     = null
}

variable "grafana_instance_id" {
  type        = string
  description = "Existing Grafana instance/workspace ID when not creating a workspace. Required by Prometheus; use \"free\" for shared free Grafana when applicable."
  default     = null
}

variable "prometheus" {
  type = map(object({
    cluster_type        = string
    cluster_name        = optional(string, null)
    cluster_id          = optional(string, null)
    vpc_id              = optional(string, null)
    vswitch_id          = optional(string, null)
    security_group_id   = optional(string, null)
    grafana_instance_id = optional(string, null)
    resource_group_id   = optional(string, null)
    payment_type        = optional(string, null)
    duration            = optional(number, null)
    archive_duration    = optional(number, null)
    sub_clusters_json   = optional(string, null)
    tags                = optional(map(string), {})
  }))
  description = "Map of ARMS Prometheus instances. cluster_type e.g. remote-write, ecs, or ack-related types. grafana_instance_id falls back to created workspace or var.grafana_instance_id."
  default     = {}
}

variable "environments" {
  type = map(object({
    environment_type     = string
    environment_sub_type = string
    environment_name     = optional(string, null)
    bind_resource_id     = optional(string, null)
    managed_type         = optional(string, null)
    drop_metrics         = optional(string, null)
    resource_group_id    = optional(string, null)
    aliyun_lang          = optional(string, null)
    tags                 = optional(map(string), {})
  }))
  description = "Optional ARMS environments"
  default     = {}
}

variable "alert_contacts" {
  type = map(object({
    alert_contact_name     = optional(string, null)
    email                  = optional(string, null)
    phone_num              = optional(string, null)
    ding_robot_webhook_url = optional(string, null)
    system_noc             = optional(bool, null)
  }))
  description = "Optional ARMS alert contacts"
  default     = {}
}

variable "alert_contact_groups" {
  type = map(object({
    alert_contact_group_name = optional(string, null)
    contact_keys             = optional(list(string), [])
    contact_ids              = optional(list(string), [])
  }))
  description = "Optional ARMS alert contact groups. contact_keys reference alert_contacts map keys."
  default     = {}
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
  description = "Additional tags"
  default     = {}
}
