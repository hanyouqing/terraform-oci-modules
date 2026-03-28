include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/logging.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  log_groups = {
    app-log-group = {
      display_name = "oci-modules-development-logs"
      description  = "Development environment application logs"
    }
  }

  logs = {
    app-log = {
      log_group_key      = "app-log-group"
      display_name       = "oci-modules-development-app-log"
      log_type           = "CUSTOM"
      is_enabled         = true
      retention_duration = 30
    }
  }
}
