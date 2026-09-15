locals {
  module_tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-alicloud-modules/emr"
    Project     = var.project
    Environment = var.environment
  }
}

resource "alicloud_emrv2_cluster" "this" {
  count = var.create_cluster ? 1 : 0

  applications         = var.applications
  cluster_name         = var.cluster_name
  cluster_type         = var.cluster_type
  release_version      = var.release_version
  payment_type         = var.payment_type
  deletion_protection  = var.deletion_protection
  deploy_mode          = var.deploy_mode
  security_mode        = var.security_mode
  log_collect_strategy = var.log_collect_strategy
  resource_group_id    = var.resource_group_id

  tags = merge(local.module_tags, var.tags)

  dynamic "node_attributes" {
    for_each = var.node_attributes
    content {
      vpc_id                 = node_attributes.value.vpc_id
      zone_id                = node_attributes.value.zone_id
      security_group_id      = node_attributes.value.security_group_id
      key_pair_name          = node_attributes.value.key_pair_name
      ram_role               = node_attributes.value.ram_role
      data_disk_encrypted    = node_attributes.value.data_disk_encrypted
      data_disk_kms_key_id   = node_attributes.value.data_disk_kms_key_id
      system_disk_encrypted  = node_attributes.value.system_disk_encrypted
      system_disk_kms_key_id = node_attributes.value.system_disk_kms_key_id
    }
  }

  dynamic "node_groups" {
    for_each = var.node_groups
    content {
      node_group_name               = node_groups.value.node_group_name
      node_group_type               = node_groups.value.node_group_type
      node_count                    = node_groups.value.node_count
      instance_types                = node_groups.value.instance_types
      payment_type                  = node_groups.value.payment_type
      vswitch_ids                   = length(node_groups.value.vswitch_ids) > 0 ? node_groups.value.vswitch_ids : null
      with_public_ip                = node_groups.value.with_public_ip
      additional_security_group_ids = length(node_groups.value.additional_security_group_ids) > 0 ? node_groups.value.additional_security_group_ids : null
      deployment_set_strategy       = node_groups.value.deployment_set_strategy
      graceful_shutdown             = node_groups.value.graceful_shutdown
      node_resize_strategy          = node_groups.value.node_resize_strategy
      spot_strategy                 = node_groups.value.spot_strategy
      spot_instance_remedy          = node_groups.value.spot_instance_remedy

      dynamic "system_disk" {
        for_each = node_groups.value.system_disk != null ? [node_groups.value.system_disk] : []
        content {
          category          = system_disk.value.category
          size              = system_disk.value.size
          count             = system_disk.value.count
          performance_level = system_disk.value.performance_level
        }
      }

      dynamic "data_disks" {
        for_each = node_groups.value.data_disks
        content {
          category          = data_disks.value.category
          size              = data_disks.value.size
          count             = data_disks.value.count
          performance_level = data_disks.value.performance_level
        }
      }

      dynamic "cost_optimized_config" {
        for_each = node_groups.value.cost_optimized_config != null ? [node_groups.value.cost_optimized_config] : []
        content {
          on_demand_base_capacity                  = cost_optimized_config.value.on_demand_base_capacity
          on_demand_percentage_above_base_capacity = cost_optimized_config.value.on_demand_percentage_above_base_capacity
          spot_instance_pools                      = cost_optimized_config.value.spot_instance_pools
        }
      }

      dynamic "spot_bid_prices" {
        for_each = node_groups.value.spot_bid_prices
        content {
          instance_type = spot_bid_prices.value.instance_type
          bid_price     = spot_bid_prices.value.bid_price
        }
      }

      dynamic "subscription_config" {
        for_each = node_groups.value.subscription_config != null ? [node_groups.value.subscription_config] : []
        content {
          payment_duration         = subscription_config.value.payment_duration
          payment_duration_unit    = subscription_config.value.payment_duration_unit
          auto_pay_order           = subscription_config.value.auto_pay_order
          auto_renew               = subscription_config.value.auto_renew
          auto_renew_duration      = subscription_config.value.auto_renew_duration
          auto_renew_duration_unit = subscription_config.value.auto_renew_duration_unit
        }
      }
    }
  }

  dynamic "application_configs" {
    for_each = var.application_configs
    content {
      application_name   = application_configs.value.application_name
      config_file_name   = application_configs.value.config_file_name
      config_item_key    = application_configs.value.config_item_key
      config_item_value  = application_configs.value.config_item_value
      config_description = application_configs.value.config_description
      config_scope       = application_configs.value.config_scope
      node_group_id      = application_configs.value.node_group_id
      node_group_name    = application_configs.value.node_group_name
    }
  }

  dynamic "bootstrap_scripts" {
    for_each = var.bootstrap_scripts
    content {
      script_name             = bootstrap_scripts.value.script_name
      script_path             = bootstrap_scripts.value.script_path
      script_args             = bootstrap_scripts.value.script_args
      execution_moment        = bootstrap_scripts.value.execution_moment
      execution_fail_strategy = bootstrap_scripts.value.execution_fail_strategy
      priority                = bootstrap_scripts.value.priority

      dynamic "node_selector" {
        for_each = bootstrap_scripts.value.node_selector
        content {
          node_select_type = node_selector.value.node_select_type
          node_group_id    = node_selector.value.node_group_id
          node_group_ids   = node_selector.value.node_group_ids
          node_group_name  = node_selector.value.node_group_name
          node_group_names = node_selector.value.node_group_names
          node_group_types = node_selector.value.node_group_types
          node_names       = node_selector.value.node_names
        }
      }
    }
  }

  dynamic "subscription_config" {
    for_each = var.subscription_config != null ? [var.subscription_config] : []
    content {
      payment_duration         = subscription_config.value.payment_duration
      payment_duration_unit    = subscription_config.value.payment_duration_unit
      auto_pay_order           = subscription_config.value.auto_pay_order
      auto_renew               = subscription_config.value.auto_renew
      auto_renew_duration      = subscription_config.value.auto_renew_duration
      auto_renew_duration_unit = subscription_config.value.auto_renew_duration_unit
    }
  }

  lifecycle {
    precondition {
      condition     = !var.create_cluster || (var.cluster_name != null && length(var.node_attributes) > 0 && length(var.node_groups) > 0)
      error_message = "create_cluster requires cluster_name, node_attributes, and node_groups."
    }
  }
}
