locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env      = local.env_vars.locals.environment
  project  = local.env_vars.locals.project
  region   = local.region_vars.locals.region
  ad_index = try(local.env_vars.locals.ad_index, 0)
}

terraform {
  source = "git::https://github.com/hanyouqing/terraform-oci-modules.git//vcn"
}

inputs = {
  vcn_display_name = "${local.project}-${local.env}-vcn"
  vcn_cidr_blocks  = ["10.0.0.0/16"]
  vcn_dns_label    = replace("${local.project}${local.env}", "-", "")

  create_internet_gateway       = true
  internet_gateway_display_name = "${local.project}-${local.env}-igw"
  internet_gateway_enabled      = true

  create_nat_gateway       = true
  nat_gateway_display_name = "${local.project}-${local.env}-nat"

  create_service_gateway       = true
  service_gateway_display_name = "${local.project}-${local.env}-sgw"
  service_gateway_services     = []

  create_drg        = false
  attach_drg_to_vcn = false

  enable_vcn_flow_logs            = false
  vcn_flow_log_retention_duration = 30

  public_subnets = {
    public-1 = {
      cidr_block          = "10.0.1.0/24"
      display_name        = "${local.project}-${local.env}-public-1"
      dns_label           = "public1"
      availability_domain = ""
    }
  }

  private_subnets = {
    private-1 = {
      cidr_block          = "10.0.10.0/24"
      display_name        = "${local.project}-${local.env}-private-1"
      dns_label           = "private1"
      availability_domain = ""
    }
  }

  network_security_groups = {}
  nsg_ingress_rules       = {}
  nsg_egress_rules        = {}
  local_peering_gateways  = {}
}
