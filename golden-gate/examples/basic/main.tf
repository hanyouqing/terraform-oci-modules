terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "golden_gate" {
  source = "../../"

  compartment_id     = var.compartment_id
  display_name       = "gg-basic"
  connection_type    = var.connection_type
  technology_type    = var.technology_type
  username           = var.username
  host               = var.host
  port               = var.port
  database_name      = var.database_name
  subnet_id          = var.subnet_id
  password_secret_id = var.password_secret_id

  project     = "golden-gate"
  environment = "development"
}
