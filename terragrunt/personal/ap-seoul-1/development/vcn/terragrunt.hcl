include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vcn.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Override subnet ADs with a data source call isn't possible in terragrunt inputs,
# so we use a placeholder — the module will use the first AD when availability_domain
# is passed as an empty string and the resource ignores empty strings.
# For production use, set real AD names here or pass via TF_VAR_*
inputs = {
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
