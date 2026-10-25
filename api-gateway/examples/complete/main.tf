terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "api_gateway" {
  source = "../../"

  compartment_id        = var.compartment_id
  display_name          = var.display_name
  subnet_id             = var.subnet_id
  endpoint_type         = var.endpoint_type
  allow_public_endpoint = var.allow_public_endpoint
  deployments           = var.deployments
  project               = "api-gateway"
  environment           = "complete"
}
