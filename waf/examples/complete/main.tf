terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "waf" {
  source = "../../"

  compartment_id          = var.compartment_id
  display_name            = var.display_name
  load_balancer_id        = var.load_balancer_id
  protection_capabilities = var.protection_capabilities
  rate_limit              = var.rate_limit

  project     = var.project
  environment = var.environment
}
