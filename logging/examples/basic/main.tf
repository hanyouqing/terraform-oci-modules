terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
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
    app-custom = {
      log_group_key      = "app-logs"
      display_name       = "app-custom-logs"
      log_type           = "CUSTOM"
      is_enabled         = true
      retention_duration = 30
    }
  }

  project     = "always-free"
  environment = "development"
}
