locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/config"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  compliance_rule_keys = length(var.compliance_pack_rule_keys) > 0 ? var.compliance_pack_rule_keys : keys(var.rules)

  aggregator_id = var.create_aggregator ? alicloud_config_aggregator.this[0].id : var.existing_aggregator_id
}

resource "alicloud_config_configuration_recorder" "this" {
  count = var.create_configuration_recorder ? 1 : 0

  enterprise_edition = var.enterprise_edition
  resource_types     = length(var.recorder_resource_types) > 0 ? var.recorder_resource_types : null
}

resource "alicloud_config_rule" "this" {
  for_each = var.rules

  rule_name                   = coalesce(each.value.rule_name, each.key)
  source_identifier           = each.value.source_identifier
  source_owner                = each.value.source_owner
  risk_level                  = each.value.risk_level
  description                 = each.value.description
  config_rule_trigger_types   = each.value.config_rule_trigger_types
  resource_types_scope        = length(each.value.resource_types_scope) > 0 ? each.value.resource_types_scope : null
  maximum_execution_frequency = each.value.maximum_execution_frequency
  region_ids_scope            = each.value.region_ids_scope
  resource_group_ids_scope    = each.value.resource_group_ids_scope
  exclude_resource_ids_scope  = each.value.exclude_resource_ids_scope
  tag_key_scope               = each.value.tag_key_scope
  tag_value_scope             = each.value.tag_value_scope
  input_parameters            = length(each.value.input_parameters) > 0 ? each.value.input_parameters : null
  status                      = each.value.status

  depends_on = [alicloud_config_configuration_recorder.this]
}

resource "alicloud_config_compliance_pack" "this" {
  count = var.create_compliance_pack ? 1 : 0

  compliance_pack_name        = var.compliance_pack_name
  description                 = var.compliance_pack_description
  risk_level                  = var.compliance_pack_risk_level
  compliance_pack_template_id = var.compliance_pack_template_id

  dynamic "config_rule_ids" {
    for_each = local.compliance_rule_keys
    content {
      config_rule_id = alicloud_config_rule.this[config_rule_ids.value].id
    }
  }

  depends_on = [alicloud_config_rule.this]
}

resource "alicloud_config_aggregator" "this" {
  count = var.create_aggregator ? 1 : 0

  aggregator_name = var.aggregator_name
  description     = var.aggregator_description
  aggregator_type = var.aggregator_type

  dynamic "aggregator_accounts" {
    for_each = var.aggregator_accounts
    content {
      account_id   = aggregator_accounts.value.account_id
      account_name = aggregator_accounts.value.account_name
      account_type = aggregator_accounts.value.account_type
    }
  }
}

resource "alicloud_config_aggregate_config_rule" "this" {
  for_each = var.aggregate_rules

  aggregate_config_rule_name  = coalesce(each.value.aggregate_config_rule_name, each.key)
  aggregator_id               = local.aggregator_id
  source_identifier           = each.value.source_identifier
  source_owner                = each.value.source_owner
  risk_level                  = each.value.risk_level
  description                 = each.value.description
  config_rule_trigger_types   = each.value.config_rule_trigger_types
  resource_types_scope        = each.value.resource_types_scope
  maximum_execution_frequency = each.value.maximum_execution_frequency
  region_ids_scope            = each.value.region_ids_scope
  resource_group_ids_scope    = each.value.resource_group_ids_scope
  exclude_resource_ids_scope  = each.value.exclude_resource_ids_scope
  tag_key_scope               = each.value.tag_key_scope
  tag_value_scope             = each.value.tag_value_scope
  input_parameters            = length(each.value.input_parameters) > 0 ? each.value.input_parameters : null
  status                      = each.value.status

  depends_on = [alicloud_config_aggregator.this]
}
