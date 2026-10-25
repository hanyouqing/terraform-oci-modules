resource "oci_pss_instance" "this" {
  compartment_id                = var.compartment_id
  identity_domain_url           = var.identity_domain_url
  admin_identity_domain_user_id = var.admin_identity_domain_user_id
  display_name                  = var.display_name

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/public-safety"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
