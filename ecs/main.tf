locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/ecs"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_instance" "this" {
  for_each = var.instances

  instance_name              = coalesce(each.value.instance_name, each.key)
  host_name                  = each.value.host_name
  description                = each.value.description
  image_id                   = each.value.image_id
  instance_type              = each.value.instance_type
  vswitch_id                 = each.value.vswitch_id
  security_groups            = each.value.security_groups
  private_ip                 = each.value.private_ip
  internet_max_bandwidth_out = each.value.internet_max_bandwidth_out
  internet_charge_type       = each.value.internet_max_bandwidth_out > 0 ? each.value.internet_charge_type : null
  key_name                   = each.value.key_name
  password                   = each.value.password
  user_data                  = each.value.user_data
  deletion_protection        = each.value.deletion_protection
  resource_group_id          = each.value.resource_group_id

  system_disk_category          = try(each.value.system_disk.category, "cloud_essd")
  system_disk_size              = try(each.value.system_disk.size, 40)
  system_disk_encrypted         = try(each.value.system_disk.encrypted, true)
  system_disk_performance_level = try(each.value.system_disk.category, "cloud_essd") == "cloud_essd" ? try(each.value.system_disk.performance_level, "PL0") : null
  system_disk_name              = try(each.value.system_disk.name, null)
  system_disk_description       = try(each.value.system_disk.description, null)

  dynamic "data_disks" {
    for_each = each.value.data_disks
    content {
      name                 = data_disks.value.name
      size                 = data_disks.value.size
      category             = try(data_disks.value.category, "cloud_essd")
      encrypted            = try(data_disks.value.encrypted, true)
      performance_level    = try(data_disks.value.category, "cloud_essd") == "cloud_essd" ? try(data_disks.value.performance_level, "PL0") : null
      delete_with_instance = try(data_disks.value.delete_with_instance, true)
      description          = data_disks.value.description
      snapshot_id          = data_disks.value.snapshot_id
    }
  }

  tags = merge(local.common_tags, each.value.tags)

  lifecycle {
    ignore_changes = [
      user_data,
      password,
    ]
  }
}
