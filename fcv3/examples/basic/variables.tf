variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "handler" {
  type        = string
  description = "Function handler"
  default     = "index.handler"
}

variable "runtime" {
  type        = string
  description = "Function runtime"
  default     = "python3.10"
}

variable "oss_bucket_name" {
  type        = string
  description = "Optional OSS bucket for code zip"
  default     = null
}

variable "oss_object_name" {
  type        = string
  description = "Optional OSS object for code zip"
  default     = null
}

variable "zip_file" {
  type        = string
  description = "Optional base64 zip_file for inline code"
  default     = null
}
