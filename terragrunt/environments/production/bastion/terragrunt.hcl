include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/bastion.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    private_subnet_ids = { "private-1" = "ocid1.subnet.oc1..mock" }
  }
}

inputs = {
  target_subnet_id             = dependency.vcn.outputs.private_subnet_ids["private-1"]
  client_cidr_block_allow_list = [get_env("TF_VAR_bastion_allowed_cidr", "0.0.0.0/0")]
  name                         = "oci-modules-production-bastion"
}
