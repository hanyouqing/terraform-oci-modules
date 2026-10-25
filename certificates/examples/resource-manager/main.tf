# Create a Vault + KMS key for CA protection (Always Free)
module "vault" {
  source = "./modules/vault"

  compartment_id     = var.compartment_ocid
  vault_display_name = "ca-vault"
  vault_type         = "DEFAULT"

  keys = {
    ca-key = {
      display_name    = "ca-master-key"
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

# Create a single root CA
module "certificates" {
  source = "./modules/certificates"

  compartment_id = var.compartment_ocid

  certificate_authorities = {
    root-ca = {
      name         = "always-free-root-ca"
      kms_key_id   = module.vault.key_ids["ca-key"]
      common_name  = "Always Free Root CA"
      organization = "My Organization"
      country      = "US"
    }
  }

  certificates = {}

  project     = "always-free"
  environment = "development"
}
