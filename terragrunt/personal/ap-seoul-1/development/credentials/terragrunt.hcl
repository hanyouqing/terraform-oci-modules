include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/credentials.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  user_ocid = trimspace(get_env("TF_VAR_user_ocid", ""))
}

# Development: empty until TF_VAR_user_ocid is set (no placeholder OCIDs).
inputs = {
  user_id = local.user_ocid != "" ? local.user_ocid : null

  auth_tokens = local.user_ocid != "" ? {
    dev-automation = {
      description = "Auth token for development automation"
    }
  } : {}
}
