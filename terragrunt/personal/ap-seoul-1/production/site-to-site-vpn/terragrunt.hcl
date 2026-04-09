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

# Production: configure CPE and IPSec connections
inputs = {
  cpes = {
    on-prem = {
      display_name = "on-premises-router"
      ip_address   = "203.0.113.1" # Replace with actual CPE IP
    }
  }

  ipsec_connections = {
    main-vpn = {
      display_name  = "production-vpn"
      drg_id        = dependency.vcn.outputs.drg_id
      cpe_key       = "on-prem"
      static_routes = ["10.0.0.0/16"]
    }
  }
}
