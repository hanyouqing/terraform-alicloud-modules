variable "region" {
  type        = string
  description = "Alibaba Cloud region"
  default     = "cn-hangzhou"
}

variable "cluster_name" {
  type        = string
  description = "ACK cluster name"
  default     = "basic-ack"
}

variable "worker_vswitch_ids" {
  type        = list(string)
  description = "Control-plane / worker vSwitch IDs"
}

variable "pod_cidr" {
  type        = string
  description = "Flannel pod CIDR"
  default     = "172.20.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR"
  default     = "172.21.0.0/20"
}

variable "instance_types" {
  type        = list(string)
  description = "Node pool instance types"
  default     = ["ecs.g7.xlarge"]
}

variable "key_name" {
  type        = string
  description = "SSH key pair name for nodes"
}
