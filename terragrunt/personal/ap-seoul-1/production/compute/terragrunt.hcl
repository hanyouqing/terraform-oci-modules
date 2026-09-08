include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/compute.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    private_subnet_ids = { "private-1" = "ocid1.subnet.oc1..mock" }
  }
}

# Production: private subnet, no public IP. Access via Bastion.
inputs = {
  subnet_id        = dependency.vcn.outputs.private_subnet_ids["private-1"]
  ssh_public_keys  = get_env("TF_VAR_ssh_public_keys", "")
  assign_public_ip = false

  shape          = "VM.Standard.E2.1.Micro"
  instance_count = 2
}
