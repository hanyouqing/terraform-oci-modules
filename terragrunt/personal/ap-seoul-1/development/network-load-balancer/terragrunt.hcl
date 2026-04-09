include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/network-load-balancer.hcl"
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

inputs = {
  subnet_id = dependency.vcn.outputs.public_subnet_ids["public-1"]

  backends = {
    backend-1 = {
      backend_set_name = "app-backend-set"
      ip_address       = "10.0.10.10"
      port             = 80
      weight           = 1
    }
  }
}
