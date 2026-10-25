output "vcn_id" {
  description = "VCN ID"
  value       = module.vcn.vcn_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vcn.public_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vcn.internet_gateway_id
}
