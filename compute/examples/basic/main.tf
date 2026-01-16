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

module "compute" {
  source = "../../"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  subnet_id      = var.subnet_id

  shape          = "VM.Standard.E2.1.Micro"
  instance_count = 1
  display_name   = "always-free-instance"

  assign_public_ip = true
  ssh_public_keys  = var.ssh_public_keys

  enable_monitoring = true
  enable_management_agent = false

  project     = "always-free"
  environment = "development"
}
