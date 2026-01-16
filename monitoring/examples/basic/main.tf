terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "monitoring" {
  source = "../../"

  compartment_id = var.compartment_id

  alarms = {
    cpu-alarm = {
      display_name          = "High CPU Usage"
      is_enabled            = true
      metric_compartment_id = var.compartment_id
      namespace             = "oci_computeagent"
      query                 = "CpuUtilization[1m].mean() > 80"
      severity              = "CRITICAL"
      message_format        = "ONS_OPTIMIZED"
      body                  = "CPU usage is above 80%"
      destinations          = []
    }
  }

  project     = "always-free"
  environment = "development"
}
