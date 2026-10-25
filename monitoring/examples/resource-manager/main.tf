module "monitoring" {
  source = "./modules/monitoring"

  compartment_id = var.compartment_ocid

  alarms = {
    cpu-alarm = {
      display_name          = "High CPU Usage"
      is_enabled            = true
      metric_compartment_id = var.compartment_ocid
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
