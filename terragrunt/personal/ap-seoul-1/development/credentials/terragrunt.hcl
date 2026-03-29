include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/credentials.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Development: create an auth token for dev automation
inputs = {
  auth_tokens = {
    dev-automation = {
      user_id     = "ocid1.user.oc1..example"
      description = "Auth token for development automation"
    }
  }
}
