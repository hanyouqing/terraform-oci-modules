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
}
