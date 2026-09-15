variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "instance_id" {
  type        = string
  description = "ECS instance ID for sample metric dimensions"
}

variable "contact_mail" {
  type        = string
  description = "Email for the primary contact (requires activation link)"
}

variable "ding_webhook" {
  type        = string
  description = "Optional DingTalk webhook URL"
  default     = null
}

variable "alarm_webhook" {
  type        = string
  description = "Optional HTTP webhook for alarm callbacks"
  default     = null
}

variable "site_monitor_address" {
  type        = string
  description = "URL monitored by the site monitor"
  default     = "https://www.aliyun.com"
}
