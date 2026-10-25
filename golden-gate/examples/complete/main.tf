terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "golden_gate" {
  source = "../../"

  compartment_id  = var.compartment_id
  display_name    = "gg-r12"
  description     = "GoldenGate Release 12 connection"
  connection_type = var.connection_type
  technology_type = var.technology_type
  subnet_id       = var.subnet_id
  vault_id        = var.vault_id

  cluster_endpoint     = var.cluster_endpoint
  workspace_url        = var.workspace_url
  rest_endpoint        = var.rest_endpoint
  provider_id          = var.provider_id
  tls_protocol         = "TLSv1.2"
  auth_token_secret_id = var.auth_token_secret_id
  deployment           = var.deployment

  project     = "golden-gate"
  environment = "production"
}
