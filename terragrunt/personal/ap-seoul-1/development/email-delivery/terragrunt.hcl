include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/email-delivery.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  sender_email = trimspace(get_env("TF_VAR_sender_email", ""))
}

inputs = {
  senders = local.sender_email != "" ? {
    noreply = {
      email_address = local.sender_email
    }
  } : {}
}
