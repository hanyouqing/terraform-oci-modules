include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/bastion.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    public_subnet_ids = { "public-1" = "ocid1.subnet.oc1..mock" }
  }
}

# Ashburn development VCN is edge-public only (no private subnet). Bastion targets the public subnet.
inputs = {
  target_subnet_id = dependency.vcn.outputs.public_subnet_ids["public-1"]
}
