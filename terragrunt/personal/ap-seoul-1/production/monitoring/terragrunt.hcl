include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/monitoring.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "notifications" {
  config_path = "../notifications"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    topic_ids = { "alerts-topic" = "ocid1.onstopic.oc1..mock" }
  }
}

inputs = {
  alarms = {
    high-cpu-alarm = {
      display_name          = "oci-modules-production-high-cpu"
      is_enabled            = true
      metric_compartment_id = get_env("TF_VAR_compartment_id", "")
      namespace             = "oci_computeagent"
      query                 = "CpuUtilization[1m].mean() > 80"
      severity              = "CRITICAL"
      message_format        = "ONS_OPTIMIZED"
      body                  = "CPU utilization is above 80% in production environment"
      destinations          = [dependency.notifications.outputs.topic_ids["alerts-topic"]]
    }
    high-memory-alarm = {
      display_name          = "oci-modules-production-high-memory"
      is_enabled            = true
      metric_compartment_id = get_env("TF_VAR_compartment_id", "")
      namespace             = "oci_computeagent"
      query                 = "MemoryUtilization[1m].mean() > 85"
      severity              = "WARNING"
      message_format        = "ONS_OPTIMIZED"
      body                  = "Memory utilization is above 85% in production environment"
      destinations          = [dependency.notifications.outputs.topic_ids["alerts-topic"]]
    }
  }
}
