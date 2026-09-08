include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/apm.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  health_url = trimspace(get_env("TF_VAR_apm_health_url", ""))
}

# Fail-closed: no synthetics until TF_VAR_apm_health_url is set.
inputs = {
  synthetics_monitors = local.health_url != "" ? {
    health-check = {
      display_name               = "app-health-check"
      apm_domain_key             = "main"
      monitor_type               = "REST"
      repeat_interval_in_seconds = 360
      target                     = local.health_url
      vantage_points             = ["OraclePublic-us-ashburn-1"]
      timeout_in_seconds         = 30
    }
  } : {}
}
