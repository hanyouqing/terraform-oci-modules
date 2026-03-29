include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/site-to-site-vpn.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    drg_id = "ocid1.drg.oc1..mock"
  }
}

# Development: no VPN connections by default (add as needed)
inputs = {}
