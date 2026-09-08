include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vcn.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Development edge profile: single public subnet + IGW only (no NAT/SGW/private).
inputs = {
  create_nat_gateway     = false
  create_service_gateway = false

  private_subnets = {}

  public_subnets = {
    public-1 = {
      cidr_block          = "10.0.1.0/24"
      display_name        = "public-1"
      dns_label           = "public1"
      availability_domain = get_env("TF_VAR_availability_domain", "")
    }
  }

  public_subnet_ingress_rules = [
    {
      protocol     = "6"
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      description  = "HTTPS"
      tcp_options  = { min = 443, max = 443 }
      udp_options  = null
      icmp_options = null
    }
  ]
}
