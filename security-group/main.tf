locals {
  common_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-alicloud-modules/security-group"
      Project     = var.project
      Environment = var.environment
    },
    var.tags
  )

  default_egress_rules = var.allow_all_egress ? {
    allow_all_outbound = {
      type                     = "egress"
      ip_protocol              = "all"
      port_range               = "-1/-1"
      cidr_ip                  = "0.0.0.0/0"
      source_security_group_id = null
      ipv6_cidr_ip             = null
      prefix_list_id           = null
      policy                   = "accept"
      priority                 = 100
      description              = "Allow all outbound traffic"
      nic_type                 = "intranet"
    }
  } : {}

  egress_rules_effective = merge(local.default_egress_rules, var.egress_rules)
}

resource "alicloud_security_group" "this" {
  security_group_name = var.security_group_name
  description         = var.description
  vpc_id              = var.vpc_id
  security_group_type = var.security_group_type
  resource_group_id   = var.resource_group_id
  tags                = local.common_tags
}

resource "alicloud_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  security_group_id        = alicloud_security_group.this.id
  type                     = coalesce(each.value.type, "ingress")
  ip_protocol              = each.value.ip_protocol
  port_range               = each.value.port_range
  cidr_ip                  = each.value.cidr_ip
  source_security_group_id = each.value.source_security_group_id
  ipv6_cidr_ip             = each.value.ipv6_cidr_ip
  prefix_list_id           = each.value.prefix_list_id
  policy                   = each.value.policy
  priority                 = each.value.priority
  description              = each.value.description
  nic_type                 = each.value.nic_type
}

resource "alicloud_security_group_rule" "egress" {
  for_each = local.egress_rules_effective

  security_group_id        = alicloud_security_group.this.id
  type                     = coalesce(each.value.type, "egress")
  ip_protocol              = each.value.ip_protocol
  port_range               = each.value.port_range
  cidr_ip                  = each.value.cidr_ip
  source_security_group_id = each.value.source_security_group_id
  ipv6_cidr_ip             = each.value.ipv6_cidr_ip
  prefix_list_id           = each.value.prefix_list_id
  policy                   = each.value.policy
  priority                 = each.value.priority
  description              = each.value.description
  nic_type                 = each.value.nic_type
}
