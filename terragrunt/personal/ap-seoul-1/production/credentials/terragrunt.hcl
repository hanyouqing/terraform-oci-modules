include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/credentials.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Production: SMTP credentials for email delivery + auth token for CI/CD
inputs = {
  auth_tokens = {
    ci-cd = {
      user_id     = "ocid1.user.oc1..example"
      description = "Auth token for CI/CD pipeline"
    }
  }

  smtp_credentials = {
    email-sender = {
      user_id     = "ocid1.user.oc1..example"
      description = "SMTP credential for email delivery"
    }
  }
}
