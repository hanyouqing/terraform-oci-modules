terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Minimal public-edge VCN: IGW + one public subnet. Ingress is caller-defined
# (example shows TCP 443 and optional SSH CIDRs). No application protocols here.
module "vcn" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid

  vcn_display_name = var.vcn_display_name
  vcn_cidr_blocks  = var.vcn_cidr_blocks
  vcn_dns_label    = var.vcn_dns_label

  create_internet_gateway = true
  create_nat_gateway      = false
  create_service_gateway  = false
  create_drg              = false
  enable_vcn_flow_logs    = false

  public_subnets = {
    edge-1 = {
      cidr_block          = var.public_subnet_cidr
      display_name        = "${var.vcn_display_name}-public"
      dns_label           = "edge1"
      availability_domain = ""
      security_list_ids   = null
    }
  }

  public_subnet_ingress_rules = concat(
    [
      {
        protocol     = "6"
        source       = "0.0.0.0/0"
        source_type  = "CIDR_BLOCK"
        description  = "HTTPS"
        tcp_options  = { min = 443, max = 443 }
        udp_options  = null
        icmp_options = null
      }
    ],
    [
      for cidr in var.ssh_allow_cidrs : {
        protocol     = "6"
        source       = cidr
        source_type  = "CIDR_BLOCK"
        description  = "SSH from allowed CIDR"
        tcp_options  = { min = 22, max = 22 }
        udp_options  = null
        icmp_options = null
      }
    ]
  )

  private_subnets = {}

  network_security_groups = var.create_edge_nsg ? {
    edge = {
      display_name  = "${var.vcn_display_name}-edge-nsg"
      freeform_tags = {}
      defined_tags  = {}
    }
  } : {}

  nsg_ingress_rules = var.create_edge_nsg ? {
    https = {
      nsg_key      = "edge"
      protocol     = "6"
      description  = "HTTPS"
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      is_stateless = false
      tcp_options = {
        destination_port_min = 443
        destination_port_max = 443
      }
      udp_options  = null
      icmp_options = null
    }
  } : {}

  nsg_egress_rules = var.create_edge_nsg ? {
    all = {
      nsg_key          = "edge"
      protocol         = "all"
      description      = "Allow all egress"
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      is_stateless     = false
      tcp_options      = null
      udp_options      = null
      icmp_options     = null
    }
  } : {}

  project     = var.project
  environment = var.environment
}
