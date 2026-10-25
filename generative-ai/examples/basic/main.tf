terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "generative_ai" {
  source = "../../"

  compartment_id = var.compartment_id
  cluster_type   = "HOSTING"
  unit_count     = var.unit_count
  unit_shape     = var.unit_shape
  display_name   = "genai-hosting"

  project     = "generative-ai"
  environment = "development"
}
