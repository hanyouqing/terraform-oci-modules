terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "apm" {
  source = "../../"

  compartment_id = var.compartment_id

  apm_domains = {
    free-domain = {
      display_name = "always-free-apm"
      description  = "Always Free APM domain for development"
      is_free_tier = true
    }
  }

  synthetics_monitors = {}

  project     = "always-free"
  environment = "development"
}
