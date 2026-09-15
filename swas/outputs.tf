output "instance_ids" {
  description = "Map of SWAS instance IDs"
  value       = { for k, v in alicloud_simple_application_server_instance.this : k => v.id }
}

output "instance_names" {
  description = "Map of SWAS instance names"
  value       = { for k, v in alicloud_simple_application_server_instance.this : k => v.instance_name }
}

output "public_ips" {
  description = "Map of public IPs when available on the resource"
  value       = { for k, v in alicloud_simple_application_server_instance.this : k => try(v.public_ip_address, try(v.public_ip, null)) }
}

output "private_ips" {
  description = "Map of private / intranet IPs when available on the resource"
  value       = { for k, v in alicloud_simple_application_server_instance.this : k => try(v.private_ip_address, try(v.inner_ip_address, try(v.intranet_ip, null))) }
}

output "status" {
  description = "Map of instance statuses when available"
  value       = { for k, v in alicloud_simple_application_server_instance.this : k => try(v.status, null) }
}

output "firewall_rule_ids" {
  description = "Map of firewall rule IDs"
  value       = { for k, v in alicloud_simple_application_server_firewall_rule.this : k => v.id }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the SWAS module"
  value = {
    next_steps = [
      "Resolve image_id / plan_id via alicloud_simple_application_server_images and _plans data sources",
      "Open only required firewall ports; avoid 0.0.0.0-wide administrative access",
      "SWAS is subscription-oriented; plan destroy carefully",
      "Prefer ECS + VPC modules for production workloads needing private networking and finer security groups"
    ]
    verification = [
      "Instance count: ${length(alicloud_simple_application_server_instance.this)}",
      "Firewall rules: ${length(alicloud_simple_application_server_firewall_rule.this)}"
    ]
    security_notes = [
      "Passwords are ignored after create; rotate via console/API if needed",
      "Firewall rules are ForceNew; changing port/protocol recreates the rule",
      "Public IPs are inherent to many SWAS plans — treat instances as internet-facing"
    ]
    cost_optimization = [
      "Pick the smallest plan_id that meets CPU/memory/traffic needs",
      "Attach data disks only when required",
      "Stop or release idle subscription instances at period boundaries"
    ]
    important_resources = {
      instance_ids = { for k, v in alicloud_simple_application_server_instance.this : k => v.id }
      public_ips   = { for k, v in alicloud_simple_application_server_instance.this : k => try(v.public_ip_address, try(v.public_ip, null)) }
      tags_note    = "common_tags defined for module parity; SWAS instance API may not accept arbitrary tags"
      module_tags  = local.common_tags
    }
  }
}
