resource "oci_tenantmanagercontrolplane_child_tenancy" "this" {
  compartment_id    = var.compartment_id
  tenancy_name      = var.tenancy_name
  home_region       = var.home_region
  admin_email       = var.admin_email
  governance_status = var.governance_status
  policy_name       = var.policy_name
  features          = length(var.features) == 0 ? null : var.features
}
