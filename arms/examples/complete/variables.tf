variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "grafana_workspace_name" {
  type        = string
  description = "Grafana workspace name"
  default     = "prod-grafana"
}

variable "grafana_workspace_edition" {
  type        = string
  description = "Grafana edition"
  default     = "standard"
}

variable "grafana_version" {
  type        = string
  description = "Grafana version"
  default     = null
}

variable "grafana_password" {
  type        = string
  description = "Optional Grafana password"
  default     = null
  sensitive   = true
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
  description = "Prometheus instances"
  default = {
    rw = {
      cluster_type = "remote-write"
      cluster_name = "prod-rw"
    }
  }
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
  description = "Alert contacts"
  default = {
    oncall = {
      email = "oncall@example.com"
    }
  }
}

variable "alert_contact_groups" {
  type = map(object({
    alert_contact_group_name = optional(string, null)
    contact_keys             = optional(list(string), [])
    contact_ids              = optional(list(string), [])
  }))
  description = "Alert contact groups"
  default = {
    sre = {
      contact_keys = ["oncall"]
    }
  }
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "alicloud-modules"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
