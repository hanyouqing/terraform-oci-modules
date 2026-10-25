module "object_storage" {
  source = "./modules/object-storage"

  compartment_id = var.compartment_ocid
  region         = var.region

  buckets = {
    app-bucket = {
      name          = "always-free-app-bucket"
      namespace     = null
      access_type   = "NoPublicAccess"
      storage_tier  = "Standard"
      versioning    = "Disabled"
      freeform_tags = {}
      defined_tags  = {}
    }
  }

  project     = "always-free"
  environment = "development"
}
