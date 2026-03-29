include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/certificates.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vault" {
  config_path = "../vault"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    key_ids = { "ca-key" = "ocid1.key.oc1..mock" }
  }
}

inputs = {}
