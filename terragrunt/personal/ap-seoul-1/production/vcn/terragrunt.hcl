include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vcn.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  enable_vcn_flow_logs            = true
  vcn_flow_log_retention_duration = 90

  # Enable only when bringing up site-to-site VPN (set TF_VAR_cpe_ip_address).
  create_drg        = trimspace(get_env("TF_VAR_cpe_ip_address", "")) != ""
  attach_drg_to_vcn = trimspace(get_env("TF_VAR_cpe_ip_address", "")) != ""

  public_subnets = {
    public-1 = {
      availability_domain = get_env("TF_VAR_availability_domain", "")
    }
  }

  private_subnets = {
    private-1 = {
      availability_domain = get_env("TF_VAR_availability_domain", "")
    }
  }

  # Least-privilege private ingress within the VCN (no 0.0.0.0/0).
  private_subnet_ingress_rules = [
    {
      protocol    = "6"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      description = "Allow SSH from VCN (bastion/jump)"
      tcp_options = { min = 22, max = 22 }
    },
    {
      protocol    = "6"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      description = "Allow HTTP from VCN (private LB/NLB)"
      tcp_options = { min = 80, max = 80 }
    },
    {
      protocol    = "6"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      description = "Allow MySQL from VCN"
      tcp_options = { min = 3306, max = 3306 }
    },
    {
      protocol    = "6"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      description = "Allow Autonomous Database SQL*Net from VCN"
      tcp_options = { min = 1521, max = 1522 }
    },
    {
      protocol    = "1"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      description = "Allow ICMP from VCN"
      icmp_options = { type = 3, code = 4 }
    }
  ]
}
