resource "oci_core_network_security_group" "this" {
  for_each = var.network_security_groups

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = each.value.display_name

  freeform_tags = merge(
    var.freeform_tags,
    each.value.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/nsg"
    }
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  for_each = var.nsg_ingress_rules

  network_security_group_id = oci_core_network_security_group.this[each.value.nsg_key].id
  direction                 = "INGRESS"
  protocol                  = each.value.protocol
  description               = each.value.description

  source      = each.value.source
  source_type = each.value.source_type

  dynamic "tcp_options" {
    for_each = each.value.protocol == "6" && each.value.tcp_options != null ? [each.value.tcp_options] : []
    content {
      destination_port_range {
        min = tcp_options.value.destination_port_min
        max = tcp_options.value.destination_port_max
      }
      source_port_range {
        min = tcp_options.value.source_port_min
        max = tcp_options.value.source_port_max
      }
    }
  }

  dynamic "udp_options" {
    for_each = each.value.protocol == "17" && each.value.udp_options != null ? [each.value.udp_options] : []
    content {
      destination_port_range {
        min = udp_options.value.destination_port_min
        max = udp_options.value.destination_port_max
      }
      source_port_range {
        min = udp_options.value.source_port_min
        max = udp_options.value.source_port_max
      }
    }
  }

  dynamic "icmp_options" {
    for_each = each.value.protocol == "1" && each.value.icmp_options != null ? [each.value.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = icmp_options.value.code
    }
  }

  is_stateless = each.value.is_stateless
}

resource "oci_core_network_security_group_security_rule" "egress" {
  for_each = var.nsg_egress_rules

  network_security_group_id = oci_core_network_security_group.this[each.value.nsg_key].id
  direction                 = "EGRESS"
  protocol                  = each.value.protocol
  description               = each.value.description

  destination      = each.value.destination
  destination_type = each.value.destination_type

  dynamic "tcp_options" {
    for_each = each.value.protocol == "6" && each.value.tcp_options != null ? [each.value.tcp_options] : []
    content {
      destination_port_range {
        min = tcp_options.value.destination_port_min
        max = tcp_options.value.destination_port_max
      }
      source_port_range {
        min = tcp_options.value.source_port_min
        max = tcp_options.value.source_port_max
      }
    }
  }

  dynamic "udp_options" {
    for_each = each.value.protocol == "17" && each.value.udp_options != null ? [each.value.udp_options] : []
    content {
      destination_port_range {
        min = udp_options.value.destination_port_min
        max = udp_options.value.destination_port_max
      }
      source_port_range {
        min = udp_options.value.source_port_min
        max = udp_options.value.source_port_max
      }
    }
  }

  dynamic "icmp_options" {
    for_each = each.value.protocol == "1" && each.value.icmp_options != null ? [each.value.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = icmp_options.value.code
    }
  }

  is_stateless = each.value.is_stateless
}
