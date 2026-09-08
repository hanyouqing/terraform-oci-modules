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
  vault_display_name = "oci-modules-production-vault"

  keys = {
    master-key = {
      display_name    = "oci-modules-production-master-key"
      algorithm       = "AES"
      length          = 32
      curve_id        = null
      protection_mode = "SOFTWARE"
    }
    # Used by certificates module (_envcommon/certificates.hcl → key_ids["ca-key"]).
    ca-key = {
      display_name    = "oci-modules-production-ca-key"
      algorithm       = "AES"
      length          = 32
      curve_id        = null
      protection_mode = "SOFTWARE"
    }
  }
}
