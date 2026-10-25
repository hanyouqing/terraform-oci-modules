terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "generative_ai" {
  source = "../../"

  compartment_id          = var.compartment_id
  cluster_type            = var.cluster_type
  unit_count              = var.unit_count
  unit_shape              = var.unit_shape
  display_name            = "genai-reserved"
  description             = "Dedicated AI cluster attached to a bring-your-own capacity reservation"
  capacity_reservation_id = var.capacity_reservation_id

  project     = "generative-ai"
  environment = "production"
}
