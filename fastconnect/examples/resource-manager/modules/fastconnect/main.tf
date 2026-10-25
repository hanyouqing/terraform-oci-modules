resource "oci_core_virtual_circuit" "this" {
  compartment_id            = var.compartment_id
  display_name              = var.display_name
  type                      = var.type
  bandwidth_shape_name      = var.bandwidth_shape_name
  customer_bgp_asn          = var.customer_bgp_asn
  gateway_id                = var.gateway_id
  provider_service_id       = var.provider_service_id
  provider_service_key_name = var.provider_service_key_name
  provider_remote_region    = var.provider_remote_region
  is_bfd_enabled            = var.is_bfd_enabled
  routing_policy            = var.routing_policy
  ip_mtu                    = var.ip_mtu

  dynamic "cross_connect_mappings" {
    for_each = var.cross_connect_mappings
    content {
      cross_connect_or_cross_connect_group_id = cross_connect_mappings.value.cross_connect_or_cross_connect_group_id
      customer_bgp_peering_ip                 = cross_connect_mappings.value.customer_bgp_peering_ip
      oracle_bgp_peering_ip                   = cross_connect_mappings.value.oracle_bgp_peering_ip
      vlan                                    = cross_connect_mappings.value.vlan
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/fastconnect"
    Project     = var.project
    Environment = var.environment
  }
}
