output "vcn_id" {
  description = "OCID of the VCN"
  value       = module.vcn.vcn_id
}

output "public_subnet_ids" {
  description = "Map of public subnet OCIDs"
  value       = module.vcn.public_subnet_ids
}

output "network_security_group_ids" {
  description = "Map of NSG OCIDs (empty when create_edge_nsg is false)"
  value       = module.vcn.network_security_group_ids
}
