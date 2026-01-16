terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "logging" {
  source = "../../"

  compartment_id = var.compartment_id

  log_groups = {
    app-logs = {
      display_name = "always-free-logs"
      description  = "Always Free application logs"
    }
  }

  logs = {
    compute-logs = {
      log_group_key     = "app-logs"
      display_name      = "compute-logs"
      log_type          = "SERVICE"
      is_enabled        = true
      retention_duration = 30
    }
  }

  project     = "always-free"
  environment = "development"
}
