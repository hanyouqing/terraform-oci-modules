include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/notifications.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  alert_email = trimspace(get_env("TF_VAR_alert_email", ""))
}

inputs = {
  topics = {
    alerts-topic = {
      name        = "oci-modules-development-alerts"
      description = "Development environment alerts"
    }
  }

  subscriptions = local.alert_email != "" ? {
    email-sub = {
      topic_key = "alerts-topic"
      protocol  = "EMAIL"
      endpoint  = local.alert_email
    }
  } : {}
}
