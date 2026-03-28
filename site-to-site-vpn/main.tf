# --- Customer-Premises Equipment (CPE) ---

resource "oci_core_cpe" "this" {
  for_each = var.cpes

  compartment_id      = var.compartment_id
  ip_address          = each.value.ip_address
  display_name        = each.value.display_name
  cpe_device_shape_id = each.value.cpe_device_shape_id
  is_private          = each.value.is_private

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/site-to-site-vpn"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

# --- IPSec Connections ---

resource "oci_core_ipsec" "this" {
  for_each = var.ipsec_connections

  compartment_id = var.compartment_id
  drg_id         = each.value.drg_id
  cpe_id         = each.value.cpe_key != null ? oci_core_cpe.this[each.value.cpe_key].id : each.value.cpe_id
  static_routes  = each.value.static_routes
  display_name   = each.value.display_name

  cpe_local_identifier      = each.value.cpe_local_identifier
  cpe_local_identifier_type = each.value.cpe_local_identifier_type

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/site-to-site-vpn"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

# --- Data source to retrieve tunnel details ---

data "oci_core_ipsec_connection_tunnels" "this" {
  for_each = var.ipsec_connections

  ipsec_id = oci_core_ipsec.this[each.key].id
}
