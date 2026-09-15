output "vpc_id" {
  description = "ID of the VPC"
  value       = alicloud_vpc.this.id
}

output "vpc_cidr_block" {
  description = "Primary CIDR block of the VPC"
  value       = alicloud_vpc.this.cidr_block
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = alicloud_vpc.this.vpc_name
}

output "route_table_id" {
  description = "System route table ID of the VPC"
  value       = alicloud_vpc.this.route_table_id
}

output "public_vswitch_ids" {
  description = "Map of public vswitch IDs"
  value       = { for k, v in alicloud_vswitch.public : k => v.id }
}

output "private_vswitch_ids" {
  description = "Map of private vswitch IDs"
  value       = { for k, v in alicloud_vswitch.private : k => v.id }
}

output "public_vswitch_cidrs" {
  description = "Map of public vswitch CIDR blocks"
  value       = { for k, v in alicloud_vswitch.public : k => v.cidr_block }
}

output "private_vswitch_cidrs" {
  description = "Map of private vswitch CIDR blocks"
  value       = { for k, v in alicloud_vswitch.private : k => v.cidr_block }
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.create_nat_gateway ? alicloud_nat_gateway.this[0].id : null
}

output "nat_gateway_snat_table_ids" {
  description = "SNAT table IDs of the NAT Gateway"
  value       = var.create_nat_gateway ? alicloud_nat_gateway.this[0].snat_table_ids : null
}

output "eip_id" {
  description = "ID of the EIP associated with the NAT Gateway"
  value       = var.create_nat_gateway ? alicloud_eip_address.nat[0].id : null
}

output "eip_address" {
  description = "Public IP address of the NAT Gateway EIP"
  value       = var.create_nat_gateway ? alicloud_eip_address.nat[0].ip_address : null
}

output "snat_entry_ids" {
  description = "Map of SNAT entry IDs for private vswitches"
  value       = { for k, v in alicloud_snat_entry.private : k => v.id }
}

output "public_route_table_ids" {
  description = "Map of custom public route table IDs"
  value       = { for k, v in alicloud_route_table.public : k => v.id }
}

output "private_route_table_ids" {
  description = "Map of custom private route table IDs"
  value       = { for k, v in alicloud_route_table.private : k => v.id }
}

output "flow_log_id" {
  description = "ID of the VPC flow log"
  value       = var.enable_flow_log ? alicloud_vpc_flow_log.this[0].id : null
}

output "zzz_reminders" {
  description = "Important reminders and next steps for the VPC module"
  value = {
    next_steps = [
      "Create security groups in the VPC before launching ECS instances",
      "Attach public-facing workloads only to public vswitches",
      "Confirm private outbound internet works via SNAT when create_nat_gateway is true",
      "Enable VPC flow logs to an existing SLS project when audit requirements apply",
      "Review custom route tables if create_private_route_tables is enabled"
    ]
    verification = [
      "Verify VPC: aliyun vpc DescribeVpcAttribute --VpcId ${alicloud_vpc.this.id}",
      "List vswitches: aliyun vpc DescribeVSwitches --VpcId ${alicloud_vpc.this.id}",
      "Verify NAT Gateway: ${var.create_nat_gateway ? "aliyun vpc DescribeNatGateways --NatGatewayId ${alicloud_nat_gateway.this[0].id}" : "Not created"}",
      "Verify EIP: ${var.create_nat_gateway ? "aliyun vpc DescribeEipAddresses --AllocationId ${alicloud_eip_address.nat[0].id}" : "Not created"}"
    ]
    security_notes = [
      "Public and private isolation is by vswitch placement; enforce access with security groups",
      "Default configuration does not open ingress; add rules in the security-group module",
      "Prefer private vswitches for application tiers; use NAT/SNAT for outbound only",
      "Flow logs require an existing SLS project and logstore"
    ]
    cost_optimization = [
      "NAT Gateway and EIP incur hourly and traffic charges; disable if private subnets need no internet",
      "Right-size nat_gateway_specification and eip_bandwidth for expected traffic",
      "Use PayByTraffic EIP charge type for bursty outbound workloads",
      "Monitor SLS ingestion costs when flow logs are enabled"
    ]
    important_resources = {
      vpc_id                = alicloud_vpc.this.id
      nat_gateway_id        = var.create_nat_gateway ? alicloud_nat_gateway.this[0].id : null
      eip_address           = var.create_nat_gateway ? alicloud_eip_address.nat[0].ip_address : null
      public_vswitch_count  = length(alicloud_vswitch.public)
      private_vswitch_count = length(alicloud_vswitch.private)
      flow_log_enabled      = var.enable_flow_log
    }
  }
}
