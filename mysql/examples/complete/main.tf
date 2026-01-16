terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

module "mysql" {
  source = "../../"

  compartment_id = var.compartment_id

  mysql_systems = var.mysql_systems

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
