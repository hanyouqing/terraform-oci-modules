include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/apm.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Development: free-tier APM domain, no monitors
inputs = {}
