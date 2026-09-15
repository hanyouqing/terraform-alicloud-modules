variable "region" {
  type        = string
  description = "Cloud Config region (cn-shanghai or ap-southeast-1)"
  default     = "cn-shanghai"
}

variable "create_aggregator" {
  type        = bool
  description = "Create an RD aggregator (requires Resource Directory / management or delegated admin)"
  default     = false
}
