include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/apm.hcl"
  expose         = true
  merge_strategy = "deep"
}

# Production: add Synthetics monitors
inputs = {
  synthetics_monitors = {
    health-check = {
      display_name               = "app-health-check"
      apm_domain_key             = "main"
      monitor_type               = "REST"
      repeat_interval_in_seconds = 360
      target                     = "https://app.example.com/health"
      vantage_points             = ["OraclePublic-us-ashburn-1"]
      timeout_in_seconds         = 30
    }
  }
}
