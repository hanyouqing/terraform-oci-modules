terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

module "vcn" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  vcn_display_name = var.vcn_display_name
  vcn_cidr_blocks  = var.vcn_cidr_blocks
  vcn_dns_label    = var.vcn_dns_label
  enable_ipv6      = var.enable_ipv6

  create_internet_gateway = true
  internet_gateway_display_name = "production-igw"
  internet_gateway_enabled = true

  create_nat_gateway      = true
  nat_gateway_display_name = "production-nat"
  nat_gateway_block_traffic = false

  create_service_gateway  = true
  service_gateway_display_name = "production-sgw"
  service_gateway_services = var.service_gateway_services

  create_drg              = var.create_drg
  drg_display_name        = var.drg_display_name
  attach_drg_to_vcn       = var.attach_drg_to_vcn

  enable_vcn_flow_logs    = var.enable_vcn_flow_logs
  vcn_flow_log_retention_duration = var.vcn_flow_log_retention_duration

  public_subnets = var.public_subnets
  private_subnets = var.private_subnets

  network_security_groups = var.network_security_groups
  nsg_ingress_rules       = var.nsg_ingress_rules
  nsg_egress_rules        = var.nsg_egress_rules

  local_peering_gateways = var.local_peering_gateways

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
