output "load_balancer_id" {
  description = "ID of the ALB instance"
  value       = alicloud_alb_load_balancer.this.id
}

output "dns_name" {
  description = "DNS name of the ALB instance"
  value       = alicloud_alb_load_balancer.this.dns_name
}

output "load_balancer_status" {
  description = "Status of the ALB instance"
  value       = alicloud_alb_load_balancer.this.status
}

output "listener_ids" {
  description = "Map of listener IDs keyed by listener map keys"
  value       = { for k, v in alicloud_alb_listener.this : k => v.id }
}

output "server_group_ids" {
  description = "Map of server group IDs keyed by server_groups map keys"
  value       = { for k, v in alicloud_alb_server_group.this : k => v.id }
}

output "zzz_reminders" {
  description = "Operational reminders for ALB"
  value = {
    next_steps = [
      "Register backend servers on server groups (ECS, ENI, or IP)",
      "For HTTPS, upload a certificate in Certificate Management Service and pass certificate_id",
      "Prefer Intranet ALB behind WAF/CDN for public internet exposure"
    ]
    security_notes = [
      "ALB does not replace security groups; restrict backend security groups to ALB traffic",
      "Enable health checks and tune thresholds before production cutover"
    ]
    cost_optimization = [
      "Standard edition costs more than Basic; choose based on feature needs",
      "Cross-zone traffic and LCU usage drive ALB cost"
    ]
    important_resources = {
      load_balancer_id   = alicloud_alb_load_balancer.this.id
      dns_name           = alicloud_alb_load_balancer.this.dns_name
      listener_count     = length(alicloud_alb_listener.this)
      server_group_count = length(alicloud_alb_server_group.this)
    }
  }
}
