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
    public_subnet_ids = { "public-1" = "ocid1.subnet.oc1..mock" }
  }
}

# Always Free ARM edge profile (2 OCPU / 12 GB / 50 GB). Caller supplies user_data.
inputs = {
  subnet_id       = dependency.vcn.outputs.public_subnet_ids["public-1"]
  ssh_public_keys = get_env("TF_VAR_ssh_public_keys", "")

  shape                          = "VM.Standard.A1.Flex"
  ocpus                          = 2
  memory_in_gbs                  = 12
  boot_volume_size_in_gbs        = 50
  instance_count                 = 1
  image_operating_system         = "Oracle Linux"
  image_operating_system_version = "9"
  assign_public_ip               = true
  # Omit empty user_data; set TF_VAR_user_data to base64 cloud-init when needed.
  user_data = length(trimspace(get_env("TF_VAR_user_data", ""))) > 0 ? get_env("TF_VAR_user_data", "") : null
}
