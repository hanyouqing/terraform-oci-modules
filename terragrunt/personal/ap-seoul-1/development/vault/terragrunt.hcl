include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/vault.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  keys = {
    master-key = {
      display_name    = "oci-modules-development-master-key"
      algorithm       = "AES"
      length          = 32
      curve_id        = null
      protection_mode = "SOFTWARE"
    }
  }
}
