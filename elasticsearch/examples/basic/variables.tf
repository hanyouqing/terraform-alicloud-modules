variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "vswitch_id" {
  type        = string
  description = "Private vSwitch ID"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used as private_whitelist"
  default     = "10.0.0.0/16"
}

variable "es_version" {
  type        = string
  description = "Elasticsearch version"
  default     = "7.10_with_X-Pack"
}

variable "data_node_spec" {
  type        = string
  description = "Data node specification"
  default     = "elasticsearch.sn2ne.large"
}

variable "password" {
  type        = string
  description = "Instance password"
  sensitive   = true
}
