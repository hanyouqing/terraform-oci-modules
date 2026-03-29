include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/compute.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    public_subnet_ids = { "public-1" = "ocid1.subnet.oc1..mock" }
  }
}

# Always Free allows 2 x VM.Standard.E2.1.Micro.
# Alternative: VM.Standard.A1.Flex with ocpus=4, memory_in_gbs=24 (Always Free ARM quota).
inputs = {
  subnet_id       = dependency.vcn.outputs.public_subnet_ids["public-1"]
  ssh_public_keys = get_env("TF_VAR_ssh_public_keys", "")

  shape          = "VM.Standard.E2.1.Micro"
  instance_count = 2
}
