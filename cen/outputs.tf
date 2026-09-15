output "cen_id" {
  description = "ID of the CEN instance"
  value       = alicloud_cen_instance.this.id
}

output "cen_instance_name" {
  description = "Name of the CEN instance"
  value       = alicloud_cen_instance.this.cen_instance_name
}

output "attachment_ids" {
  description = "Map of classic CEN child instance attachment IDs"
  value       = { for k, v in alicloud_cen_instance_attachment.this : k => v.id }
}

output "bandwidth_package_id" {
  description = "ID of the CEN bandwidth package"
  value       = var.create_bandwidth_package ? alicloud_cen_bandwidth_package.this[0].id : null
}

output "bandwidth_package_attachment_id" {
  description = "ID of the CEN bandwidth package attachment"
  value       = var.create_bandwidth_package ? alicloud_cen_bandwidth_package_attachment.this[0].id : null
}

output "bandwidth_limit_ids" {
  description = "Map of inter-region bandwidth limit IDs"
  value       = { for k, v in alicloud_cen_bandwidth_limit.this : k => v.id }
}

output "transit_router_id" {
  description = "Transit router ID when create_transit_router is true"
  value       = var.create_transit_router ? try(alicloud_cen_transit_router.this[0].transit_router_id, alicloud_cen_transit_router.this[0].id) : null
}

output "transit_router_vpc_attachment_ids" {
  description = "Map of transit router VPC attachment IDs"
  value = {
    for k, v in alicloud_cen_transit_router_vpc_attachment.this :
    k => try(v.transit_router_attachment_id, v.id)
  }
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the CEN module"
  value = {
    next_steps = [
      "Attach VPCs/VBRs in each region that needs private connectivity",
      "For cross-region bandwidth, create a bandwidth package covering the geographic areas and set bandwidth_limits",
      "For 海外 / cross-region Express Connect (高速通道) handoff, pair this module with an express-connect (VBR / physical connection) module",
      "Prefer transit router attachments for TR-based topologies; classic attachments remain for VPC/VBR/CCN"
    ]
    verification = [
      "CEN ID: ${alicloud_cen_instance.this.id}",
      "Attachments: ${length(alicloud_cen_instance_attachment.this)}",
      "Bandwidth package: ${var.create_bandwidth_package ? alicloud_cen_bandwidth_package.this[0].id : "not created"}"
    ]
    security_notes = [
      "CEN extends private routing; combine with security groups and NACLs at each VPC",
      "Cross-account attachments require child_instance_owner_id",
      "Do not attach the same network instance to multiple conflicting CEN topologies"
    ]
    cost_optimization = [
      "Cross-region bandwidth packages incur ongoing charges; size bandwidth_limits carefully",
      "Prefer PostPaid bandwidth packages for non-production",
      "Within-region VPC attachments may not need a cross-area bandwidth package"
    ]
    important_resources = {
      cen_id               = alicloud_cen_instance.this.id
      attachment_ids       = { for k, v in alicloud_cen_instance_attachment.this : k => v.id }
      bandwidth_package_id = var.create_bandwidth_package ? alicloud_cen_bandwidth_package.this[0].id : null
      transit_router_id    = var.create_transit_router ? try(alicloud_cen_transit_router.this[0].transit_router_id, alicloud_cen_transit_router.this[0].id) : null
    }
  }
}
