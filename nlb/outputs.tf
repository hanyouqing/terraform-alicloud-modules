output "load_balancer_id" {
  description = "ID of the NLB instance"
  value       = alicloud_nlb_load_balancer.this.id
}

output "dns_name" {
  description = "DNS name of the NLB instance"
  value       = alicloud_nlb_load_balancer.this.dns_name
}

output "load_balancer_status" {
  description = "Status of the NLB instance"
  value       = alicloud_nlb_load_balancer.this.status
}

output "listener_ids" {
  description = "Map of listener IDs keyed by listener map keys"
  value       = { for k, v in alicloud_nlb_listener.this : k => v.id }
}

output "server_group_ids" {
  description = "Map of server group IDs keyed by server_groups map keys"
  value       = { for k, v in alicloud_nlb_server_group.this : k => v.id }
}

output "server_attachment_ids" {
  description = "Map of server group server attachment IDs"
  value       = { for k, v in alicloud_nlb_server_group_server_attachment.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for NLB"
  value = {
    next_steps = [
      "Register backend servers on server groups (ECS, ENI, ECI, or IP)",
      "For TCPSSL, upload certificates and pass certificate_ids",
      "Point DNS / PrivateZone records at dns_name for service discovery"
    ]
    security_notes = [
      "Prefer Intranet NLB; expose public traffic via WAF/CDN or controlled Internet NLB",
      "Attach security_group_ids and lock backend SGs to NLB traffic only"
    ]
    cost_optimization = [
      "NLB is billed by LCU and traffic; right-size listeners and idle_timeout",
      "Disable unused listeners and empty server groups"
    ]
    important_resources = {
      load_balancer_id   = alicloud_nlb_load_balancer.this.id
      dns_name           = alicloud_nlb_load_balancer.this.dns_name
      listener_count     = length(alicloud_nlb_listener.this)
      server_group_count = length(alicloud_nlb_server_group.this)
    }
  }
}
