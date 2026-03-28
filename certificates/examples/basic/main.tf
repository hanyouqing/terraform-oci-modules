terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

# Create a Vault + KMS key for CA protection (Always Free)
module "vault" {
  source = "../../../vault"

  compartment_id     = var.compartment_id
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
  source = "../../"

  compartment_id = var.compartment_id

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
