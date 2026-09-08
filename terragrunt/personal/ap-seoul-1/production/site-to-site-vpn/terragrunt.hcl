include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/site-to-site-vpn.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    drg_id = "ocid1.drg.oc1..mock"
  }
}

locals {
  cpe_ip = trimspace(get_env("TF_VAR_cpe_ip_address", ""))
}

# Production: no VPN by default. Set TF_VAR_cpe_ip_address and enable DRG on the VCN stack first.
inputs = {
  cpes = local.cpe_ip != "" ? {
    on-prem = {
      display_name = "on-premises-router"
      ip_address   = local.cpe_ip
    }
  } : {}

  ipsec_connections = local.cpe_ip != "" ? {
    main-vpn = {
      display_name  = "production-vpn"
      drg_id        = dependency.vcn.outputs.drg_id
      cpe_key       = "on-prem"
      static_routes = ["10.0.0.0/16"]
    }
  } : {}
}
