include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/load-balancer.hcl"
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

dependency "compute" {
  config_path = "../compute"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    instance_private_ips = ["10.0.2.10", "10.0.2.11"]
  }
}

# Production: private flexible LB in private subnet; backends from compute private IPs.
inputs = {
  is_private = true
  subnet_ids = [dependency.vcn.outputs.private_subnet_ids["private-1"]]

  backends = {
    for idx, ip in dependency.compute.outputs.instance_private_ips : "backend-${idx + 1}" => {
      backendset_name = "app-backend-set"
      ip_address      = ip
      port            = 80
      backup          = false
      drain           = false
      offline         = false
      weight          = 1
    }
  }
}
