output "vcn_id" {
  description = "VCN ID"
  value       = module.vcn.vcn_id
}

output "vcn_cidr_blocks" {
  description = "VCN CIDR blocks"
  value       = module.vcn.vcn_cidr_blocks
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vcn.internet_gateway_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vcn.nat_gateway_id
}

output "service_gateway_id" {
  description = "Service Gateway ID"
  value       = module.vcn.service_gateway_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vcn.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vcn.private_subnet_ids
}

output "network_security_group_ids" {
  description = "Network Security Group IDs"
  value       = module.vcn.network_security_group_ids
}

output "drg_id" {
  description = "Dynamic Routing Gateway ID"
  value       = module.vcn.drg_id
}

output "local_peering_gateway_ids" {
  description = "Local Peering Gateway IDs"
  value       = module.vcn.local_peering_gateway_ids
}

output "vcn_flow_log_id" {
  description = "VCN Flow Log ID"
  value       = module.vcn.vcn_flow_log_id
}
