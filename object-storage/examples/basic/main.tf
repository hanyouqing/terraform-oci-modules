terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "object_storage" {
  source = "../../"

  compartment_id = var.compartment_id
  region         = var.region

  buckets = {
    app-bucket = {
      name         = "always-free-app-bucket"
      namespace    = null
      access_type  = "NoPublicAccess"
      storage_tier = "Standard"
      versioning   = "Disabled"
      freeform_tags = {}
      defined_tags  = {}
    }
  }

  project     = "always-free"
  environment = "development"
}
