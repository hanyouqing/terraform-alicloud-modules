locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/ack"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  cni_addon_name = var.network_plugin == "terway" ? "terway-eniip" : "flannel"

  user_addon_names = [for a in var.addons : a.name]

  effective_addons = concat(
    contains(local.user_addon_names, local.cni_addon_name) ? [] : [{
      name     = local.cni_addon_name
      config   = null
      version  = null
      disabled = false
    }],
    var.addons
  )
}

resource "alicloud_cs_managed_kubernetes" "this" {
  name         = var.cluster_name
  version      = var.kubernetes_version
  cluster_spec = var.cluster_spec
  # Provider prefers vswitch_ids; module input remains worker_vswitch_ids for API clarity.
  vswitch_ids                    = var.worker_vswitch_ids
  pod_vswitch_ids                = var.network_plugin == "terway" ? var.pod_vswitch_ids : null
  pod_cidr                       = var.network_plugin == "flannel" ? var.pod_cidr : null
  service_cidr                   = var.service_cidr
  node_cidr_mask                 = var.network_plugin == "flannel" ? var.node_cidr_mask : null
  new_nat_gateway                = var.new_nat_gateway
  deletion_protection            = var.deletion_protection
  slb_internet_enabled = var.slb_internet_enabled
  proxy_mode                     = var.proxy_mode
  is_enterprise_security_group   = var.security_group_id == null ? var.is_enterprise_security_group : null
  security_group_id              = var.security_group_id
  resource_group_id              = var.resource_group_id
  enable_rrsa                    = var.enable_rrsa
  skip_set_certificate_authority = var.skip_set_certificate_authority
  timezone                       = var.timezone
  tags                           = local.common_tags

  dynamic "addons" {
    for_each = local.effective_addons
    content {
      name     = addons.value.name
      config   = addons.value.config
      version  = addons.value.version
      disabled = addons.value.disabled
    }
  }

  lifecycle {
    precondition {
      condition     = var.network_plugin != "flannel" || (var.pod_cidr != null && can(cidrnetmask(var.pod_cidr)))
      error_message = "network_plugin=flannel requires a valid pod_cidr."
    }

    precondition {
      condition     = var.network_plugin != "terway" || length(var.pod_vswitch_ids) > 0
      error_message = "network_plugin=terway requires pod_vswitch_ids."
    }
  }
}

resource "alicloud_cs_kubernetes_node_pool" "this" {
  for_each = var.node_pools

  cluster_id                    = alicloud_cs_managed_kubernetes.this.id
  node_pool_name                = each.key
  vswitch_ids                   = each.value.vswitch_ids
  instance_types                = each.value.instance_types
  desired_size                  = each.value.scaling_config == null ? each.value.desired_size : null
  key_name                      = each.value.key_name
  password                      = each.value.password
  install_cloud_monitor         = each.value.install_cloud_monitor
  system_disk_category          = each.value.system_disk_category
  system_disk_size              = each.value.system_disk_size
  system_disk_encrypted         = each.value.system_disk_encrypted
  system_disk_performance_level = each.value.system_disk_category == "cloud_essd" ? each.value.system_disk_performance_level : null
  image_type                    = each.value.image_type
  instance_charge_type          = each.value.instance_charge_type
  tags                          = merge(local.common_tags, each.value.tags)

  dynamic "scaling_config" {
    for_each = each.value.scaling_config != null ? [each.value.scaling_config] : []
    content {
      min_size = scaling_config.value.min_size
      max_size = scaling_config.value.max_size
      type     = scaling_config.value.type
      enable   = scaling_config.value.enable
    }
  }

  dynamic "data_disks" {
    for_each = each.value.data_disks
    content {
      category          = try(data_disks.value.category, "cloud_essd")
      size              = data_disks.value.size
      encrypted         = try(data_disks.value.encrypted, true)
      performance_level = try(data_disks.value.category, "cloud_essd") == "cloud_essd" ? try(data_disks.value.performance_level, "PL0") : null
    }
  }

  dynamic "labels" {
    for_each = each.value.labels
    content {
      key   = labels.key
      value = labels.value
    }
  }

  lifecycle {
    ignore_changes = [password]
  }
}
