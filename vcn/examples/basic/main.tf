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

  vcn_display_name = "always-free-vcn"
  vcn_cidr_blocks  = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = false
  create_service_gateway  = false
  create_drg              = false
  enable_vcn_flow_logs    = false

  public_subnets = {
    public-subnet-1 = {
      cidr_block          = "10.0.1.0/24"
      display_name        = "public-subnet-1"
      dns_label           = "public1"
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      security_list_ids   = null
    }
  }

  public_subnet_ingress_rules = [
    { protocol = "6", source = "0.0.0.0/0", source_type = "CIDR_BLOCK", description = "Allow SSH from anywhere", tcp_options = { min = 22, max = 22 }, udp_options = null, icmp_options = null },
    { protocol = "6", source = "0.0.0.0/0", source_type = "CIDR_BLOCK", description = "Allow HTTP from anywhere", tcp_options = { min = 80, max = 80 }, udp_options = null, icmp_options = null },
    { protocol = "6", source = "0.0.0.0/0", source_type = "CIDR_BLOCK", description = "Allow HTTPS from anywhere", tcp_options = { min = 443, max = 443 }, udp_options = null, icmp_options = null },
  ]

  private_subnets = {}

  project     = "always-free"
  environment = "development"
}
