locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/kafka"
    Project     = var.project
    Environment = var.environment
  }

  instance_id = var.create_instance ? alicloud_alikafka_instance.this[0].id : var.instance_id
}

resource "alicloud_alikafka_instance" "this" {
  count = var.create_instance ? 1 : 0

  name              = var.instance_name
  deploy_type       = var.deploy_type
  vpc_id            = var.vpc_id
  vswitch_id        = length(var.vswitch_ids) == 0 ? var.vswitch_id : null
  vswitch_ids       = length(var.vswitch_ids) > 0 ? var.vswitch_ids : null
  security_group    = var.security_group
  disk_type         = var.disk_type
  disk_size         = var.disk_size
  partition_num     = var.partition_num
  topic_quota       = var.topic_quota
  io_max            = var.io_max
  io_max_spec       = var.io_max_spec
  spec_type         = var.spec_type
  paid_type         = var.paid_type
  service_version   = var.service_version
  kms_key_id        = var.kms_key_id
  selected_zones    = length(var.selected_zones) > 0 ? var.selected_zones : null
  config            = var.config
  eip_max           = var.eip_max
  resource_group_id = var.resource_group_id

  tags = merge(local.module_tags, var.tags)

  lifecycle {
    precondition {
      condition     = var.deploy_type != 5 || (var.vpc_id != null && (var.vswitch_id != null || length(var.vswitch_ids) > 0))
      error_message = "deploy_type 5 (VPC) requires vpc_id and vswitch_id or vswitch_ids."
    }
  }
}

resource "alicloud_alikafka_topic" "this" {
  for_each = var.topics

  instance_id   = local.instance_id
  topic         = coalesce(each.value.topic, each.key)
  remark        = each.value.remark
  partition_num = each.value.partition_num
  compact_topic = each.value.compact_topic
  local_topic   = each.value.local_topic
  configs       = each.value.configs
  tags          = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_alikafka_consumer_group" "this" {
  for_each = var.consumer_groups

  instance_id = local.instance_id
  consumer_id = coalesce(each.value.consumer_id, each.key)
  description = each.value.description
  remark      = each.value.remark
  tags        = merge(local.module_tags, var.tags, each.value.tags)
}

resource "alicloud_alikafka_sasl_user" "this" {
  for_each = var.sasl_users

  instance_id            = local.instance_id
  username               = coalesce(each.value.username, each.key)
  password               = each.value.password
  type                   = each.value.type
  mechanism              = each.value.mechanism
  kms_encrypted_password = each.value.kms_encrypted_password
  kms_encryption_context = length(each.value.kms_encryption_context) > 0 ? each.value.kms_encryption_context : null
}
