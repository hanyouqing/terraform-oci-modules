include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/apm.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Development: free-tier APM domain, no monitors
inputs = {}
