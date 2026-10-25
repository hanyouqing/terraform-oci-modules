module "vault" {
  source = "./modules/vault"

  compartment_id     = var.compartment_ocid
  vault_display_name = "always-free-vault"
  vault_type         = "DEFAULT"

  keys = {
    master-key = {
      display_name    = "always-free-master-key"
      algorithm       = "AES"
      length          = 32
      curve_id        = null
      protection_mode = "SOFTWARE"
    }
  }

  secrets = {}

  project     = "always-free"
  environment = "development"
}
