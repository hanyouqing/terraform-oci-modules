resource "oci_golden_gate_deployment" "this" {
  count = var.deployment == null ? 0 : 1

  compartment_id  = var.compartment_id
  display_name    = var.deployment.display_name
  subnet_id       = var.deployment.subnet_id
  deployment_type = var.deployment.deployment_type
  license_model   = var.deployment.license_model
  cpu_core_count  = var.deployment.cpu_core_count
  is_public       = var.deployment.is_public
  nsg_ids         = var.deployment.nsg_ids

  ogg_data {
    admin_username     = var.deployment.admin_username
    password_secret_id = var.deployment.password_secret_id
    ogg_version        = var.deployment.ogg_version
    credential_store   = "GOLDENGATE"
  }

  freeform_tags = merge(
    {
      ManagedBy   = "terraform"
      Module      = "github.com/hanyouqing/terraform-oci-modules/golden-gate"
      Project     = var.project
      Environment = var.environment
    },
    var.freeform_tags,
  )
  defined_tags = var.defined_tags
}
