terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "exadata" {
  source = "../../"

  compartment_id          = var.compartment_id
  availability_domain     = var.availability_domain
  display_name            = var.display_name
  shape                   = var.shape
  compute_count           = var.compute_count
  storage_count           = var.storage_count
  customer_contact_emails = var.customer_contact_emails
  vm_cluster              = var.vm_cluster

  project     = var.project
  environment = var.environment
}
