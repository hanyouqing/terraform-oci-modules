resource "oci_core_drg" "this" {
  count = var.create_drg ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = var.drg_display_name

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/drg"
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_drg_attachment" "vcn" {
  count = var.create_drg && var.attach_drg_to_vcn ? 1 : 0

  drg_id = oci_core_drg.this[0].id
  network_details {
    id   = oci_core_vcn.this.id
    type = "VCN"
  }
  display_name = "${var.vcn_display_name}-drg-attachment"

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/drg-attachment"
    }
  )
}

resource "oci_core_drg_route_table" "this" {
  for_each = var.drg_route_tables

  drg_id       = oci_core_drg.this[0].id
  display_name = each.value.display_name

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/drg-route-table"
    }
  )
}

resource "oci_core_drg_route_distribution" "this" {
  for_each = var.drg_route_distributions

  drg_id            = oci_core_drg.this[0].id
  display_name      = each.value.display_name
  distribution_type = each.value.distribution_type

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/drg-route-distribution"
    }
  )
}

resource "oci_core_local_peering_gateway" "this" {
  for_each = var.local_peering_gateways

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = each.value.display_name
  route_table_id = each.value.route_table_id
  peer_id        = each.value.peer_id

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/lpg"
    }
  )

  defined_tags = var.defined_tags
}
