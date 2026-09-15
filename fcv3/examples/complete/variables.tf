variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "functions" {
  type = map(object({
    handler               = string
    runtime               = string
    function_name         = optional(string, null)
    description           = optional(string, null)
    timeout               = optional(number, null)
    memory_size           = optional(number, null)
    cpu                   = optional(number, null)
    disk_size             = optional(number, null)
    instance_concurrency  = optional(number, null)
    internet_access       = optional(bool, null)
    role                  = optional(string, null)
    layers                = optional(list(string), [])
    environment_variables = optional(map(string), {})
    resource_group_id     = optional(string, null)
    tags                  = optional(map(string), {})
    code = optional(object({
      oss_bucket_name = optional(string, null)
      oss_object_name = optional(string, null)
      zip_file        = optional(string, null)
      checksum        = optional(string, null)
    }), null)
    vpc_config = optional(object({
      vpc_id            = optional(string, null)
      vswitch_ids       = optional(list(string), null)
      security_group_id = optional(string, null)
    }), null)
    log_config = optional(object({
      project                 = optional(string, null)
      logstore                = optional(string, null)
      enable_instance_metrics = optional(bool, null)
      enable_request_metrics  = optional(bool, null)
      log_begin_rule          = optional(string, null)
    }), null)
    gpu_config = optional(object({
      gpu_memory_size = optional(number, null)
      gpu_type        = optional(string, null)
    }), null)
  }))
  description = "Functions map"
  default     = {}
}

variable "triggers" {
  type = map(object({
    function_key    = string
    trigger_type    = string
    qualifier       = optional(string, "LATEST")
    trigger_name    = optional(string, null)
    description     = optional(string, null)
    source_arn      = optional(string, null)
    invocation_role = optional(string, null)
    trigger_config  = optional(string, null)
  }))
  description = "Optional triggers"
  default     = {}
}

variable "custom_domains" {
  type = map(object({
    custom_domain_name = optional(string, null)
    protocol           = optional(string, null)
    certificate_id     = optional(string, null)
    auth_config = optional(object({
      auth_type = optional(string, null)
      auth_info = optional(string, null)
    }), null)
    cert_config = optional(object({
      cert_name   = optional(string, null)
      certificate = optional(string, null)
      private_key = optional(string, null)
    }), null)
    route_config = optional(object({
      routes = optional(list(object({
        function_name = optional(string, null)
        function_key  = optional(string, null)
        path          = optional(string, null)
        methods       = optional(list(string), null)
        qualifier     = optional(string, null)
      })), [])
    }), null)
    tls_config = optional(object({
      min_version   = optional(string, null)
      max_version   = optional(string, null)
      cipher_suites = optional(list(string), null)
    }), null)
    waf_config = optional(object({
      enable_waf = optional(bool, null)
    }), null)
    cors_config = optional(object({
      allow_credentials = optional(bool, null)
      allow_headers     = optional(list(string), null)
      allow_methods     = optional(list(string), null)
      allow_origins     = optional(list(string), null)
      expose_headers    = optional(list(string), null)
      max_age           = optional(number, null)
    }), null)
  }))
  description = "Optional custom domains"
  default     = {}
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
