output "security_group_id" {
  description = "ID of the security group"
  value       = alicloud_security_group.this.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = alicloud_security_group.this.security_group_name
}

output "ingress_rule_ids" {
  description = "Map of ingress rule IDs"
  value       = { for k, v in alicloud_security_group_rule.ingress : k => v.id }
}

output "egress_rule_ids" {
  description = "Map of egress rule IDs"
  value       = { for k, v in alicloud_security_group_rule.egress : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the security-group module"
  value = {
    next_steps = [
      "Attach the security group to ECS instances via the ecs module",
      "Add least-privilege ingress rules (CIDR or source security group)",
      "Set allow_all_egress=false and define egress_rules when locking down outbound traffic",
      "Prefer source_security_group_id over wide CIDRs for east-west traffic"
    ]
    security_notes = [
      "Default ingress is empty (locked down)",
      "Default egress allows all outbound (allow_all_egress=true) for usability",
      "Avoid 0.0.0.0/0 ingress except for intentionally public listeners",
      "Use priority carefully; lower numbers take precedence"
    ]
    important_resources = {
      security_group_id  = alicloud_security_group.this.id
      ingress_rule_count = length(alicloud_security_group_rule.ingress)
      egress_rule_count  = length(alicloud_security_group_rule.egress)
      allow_all_egress   = var.allow_all_egress
    }
  }
}
