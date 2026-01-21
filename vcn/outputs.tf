output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.this.id
}

output "vcn_cidr_blocks" {
  description = "CIDR blocks of the VCN"
  value       = oci_core_vcn.this.cidr_blocks
}

output "vcn_display_name" {
  description = "Display name of the VCN"
  value       = oci_core_vcn.this.display_name
}

output "internet_gateway_id" {
  description = "OCID of the Internet Gateway"
  value       = var.create_internet_gateway ? oci_core_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "OCID of the NAT Gateway"
  value       = var.create_nat_gateway ? oci_core_nat_gateway.this[0].id : null
}

output "service_gateway_id" {
  description = "OCID of the Service Gateway"
  value       = var.create_service_gateway ? oci_core_service_gateway.this[0].id : null
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = { for k, v in oci_core_subnet.public : k => v.id }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value       = { for k, v in oci_core_subnet.private : k => v.id }
}

output "public_subnet_cidrs" {
  description = "Map of public subnet CIDR blocks"
  value       = { for k, v in oci_core_subnet.public : k => v.cidr_block }
}

output "private_subnet_cidrs" {
  description = "Map of private subnet CIDR blocks"
  value       = { for k, v in oci_core_subnet.private : k => v.cidr_block }
}

output "public_route_table_ids" {
  description = "Map of public route table IDs"
  value       = { for k, v in oci_core_route_table.public : k => v.id }
}

output "private_route_table_ids" {
  description = "Map of private route table IDs"
  value       = { for k, v in oci_core_route_table.private : k => v.id }
}

output "public_security_list_ids" {
  description = "Map of public security list IDs"
  value       = { for k, v in oci_core_security_list.public : k => v.id }
}

output "private_security_list_ids" {
  description = "Map of private security list IDs"
  value       = { for k, v in oci_core_security_list.private : k => v.id }
}

output "availability_domains" {
  description = "List of availability domain names"
  value       = data.oci_identity_availability_domains.ads.availability_domains[*].name
}

output "network_security_group_ids" {
  description = "Map of Network Security Group IDs"
  value       = { for k, v in oci_core_network_security_group.this : k => v.id }
}

output "drg_id" {
  description = "OCID of the Dynamic Routing Gateway"
  value       = var.create_drg ? oci_core_drg.this[0].id : null
}

output "drg_attachment_id" {
  description = "OCID of the DRG attachment to VCN"
  value       = var.create_drg && var.attach_drg_to_vcn ? oci_core_drg_attachment.vcn[0].id : null
}

output "local_peering_gateway_ids" {
  description = "Map of Local Peering Gateway IDs"
  value       = { for k, v in oci_core_local_peering_gateway.this : k => v.id }
}

output "vcn_flow_log_id" {
  description = "OCID of the VCN Flow Log"
  value       = var.enable_vcn_flow_logs ? oci_core_vcn_flow_log.this[0].id : null
}

output "zzz_reminders" {
  description = "Important reminders and next steps for VCN module"
  value = {
    next_steps = [
      "Review security list rules to ensure appropriate ingress/egress rules",
      "Configure Network Security Groups (NSGs) if using micro-segmentation",
      "Verify route tables are correctly configured for public/private subnets",
      "Test connectivity from compute instances in public and private subnets",
      "Monitor NAT Gateway data processing costs if enabled"
    ]
    verification = [
      "Verify VCN is created: oci network vcn get --vcn-id ${oci_core_vcn.this.id}",
      "Check subnets: oci network subnet list --compartment-id ${var.compartment_id}",
      "Verify Internet Gateway: ${var.create_internet_gateway ? "oci network internet-gateway get --ig-id ${oci_core_internet_gateway.this[0].id}" : "Not created"}",
      "Verify NAT Gateway: ${var.create_nat_gateway ? "oci network nat-gateway get --nat-gateway-id ${oci_core_nat_gateway.this[0].id}" : "Not created"}"
    ]
    security_notes = [
      "Default security lists allow all traffic - restrict as needed",
      "Use NSGs for fine-grained network security (recommended)",
      "Private subnets should not have direct internet access (use NAT Gateway)",
      "Review and restrict security list rules to minimum required"
    ]
    cost_optimization = [
      "NAT Gateway costs ~$32-35/month + data processing fees",
      "Disable NAT Gateway if private subnets don't need internet access",
      "Use Service Gateway for OCI service access (free alternative to NAT)",
      "Monitor Flow Logs storage costs if enabled"
    ]
    important_resources = {
      vcn_id               = oci_core_vcn.this.id
      internet_gateway_id  = var.create_internet_gateway ? oci_core_internet_gateway.this[0].id : null
      nat_gateway_id       = var.create_nat_gateway ? oci_core_nat_gateway.this[0].id : null
      service_gateway_id   = var.create_service_gateway ? oci_core_service_gateway.this[0].id : null
      public_subnet_count  = length(oci_core_subnet.public)
      private_subnet_count = length(oci_core_subnet.private)
    }
  }
}
