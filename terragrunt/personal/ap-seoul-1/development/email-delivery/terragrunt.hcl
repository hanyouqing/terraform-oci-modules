include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/email-delivery.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  senders = {
    noreply = {
      email_address = get_env("TF_VAR_sender_email", "noreply@example.com")
    }
  }
}
