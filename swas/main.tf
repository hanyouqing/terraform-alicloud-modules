locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/swas"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )
}

resource "alicloud_simple_application_server_instance" "this" {
  for_each = var.instances

  instance_name  = coalesce(each.value.instance_name, each.key)
  image_id       = each.value.image_id
  plan_id        = each.value.plan_id
  payment_type   = each.value.payment_type
  period         = each.value.period
  data_disk_size = each.value.data_disk_size
  password       = each.value.password

  lifecycle {
    ignore_changes = [password]
  }
}

resource "alicloud_simple_application_server_firewall_rule" "this" {
  for_each = var.firewall_rules

  instance_id   = alicloud_simple_application_server_instance.this[each.value.instance_key].id
  rule_protocol = each.value.rule_protocol
  port          = each.value.port
  remark        = coalesce(each.value.remark, each.key)
}
