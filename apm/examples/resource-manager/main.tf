module "apm" {
  source = "./modules/apm"

  compartment_id = var.compartment_ocid

  apm_domains = {
    free-domain = {
      display_name = "always-free-apm"
      description  = "Always Free APM domain for development"
      is_free_tier = true
    }
  }

  synthetics_monitors = {}

  project     = "always-free"
  environment = "development"
}
