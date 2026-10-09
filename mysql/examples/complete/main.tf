terraform {
  required_version = ">= 1.16.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.9"
    }
  }
}

provider "oci" {}

module "mysql" {
  source = "../../"

  compartment_id = var.compartment_id

  mysql_systems = var.mysql_systems

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
