include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/notifications.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  topics = {
    alerts-topic = {
      name        = "oci-modules-production-alerts"
      description = "Production environment alerts"
    }
  }

  subscriptions = {
    email-sub = {
      topic_key = "alerts-topic"
      protocol  = "EMAIL"
      endpoint  = get_env("TF_VAR_alert_email", "admin@example.com")
    }
  }
}
