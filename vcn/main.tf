data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name
  cidr_blocks    = var.vcn_cidr_blocks
  dns_label      = var.vcn_dns_label != null && var.vcn_dns_label != "" ? var.vcn_dns_label : null
  is_ipv6enabled = var.enable_ipv6

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/vcn"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.internet_gateway_display_name
  enabled        = var.internet_gateway_enabled

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/internet-gateway"
    }
  )
}

resource "oci_core_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.nat_gateway_display_name
  block_traffic  = var.nat_gateway_block_traffic

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/nat-gateway"
    }
  )
}

resource "oci_core_service_gateway" "this" {
  count = var.create_service_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.service_gateway_display_name

  dynamic "services" {
    for_each = var.service_gateway_services
    content {
      service_id = services.value.service_id
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/service-gateway"
    }
  )
}

resource "oci_core_subnet" "public" {
  for_each = var.public_subnets

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.display_name
  dns_label                  = each.value.dns_label != "" ? each.value.dns_label : null
  availability_domain        = each.value.availability_domain
  prohibit_public_ip_on_vnic = false
  security_list_ids          = each.value.security_list_ids != null ? each.value.security_list_ids : [oci_core_security_list.public[each.key].id]

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/subnet/public"
      "Type"      = "public"
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_subnet" "private" {
  for_each = var.private_subnets

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.display_name
  dns_label                  = each.value.dns_label != "" ? each.value.dns_label : null
  availability_domain        = each.value.availability_domain
  prohibit_public_ip_on_vnic = true
  security_list_ids          = each.value.security_list_ids != null ? each.value.security_list_ids : [oci_core_security_list.private[each.key].id]

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/subnet/private"
      "Type"      = "private"
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_route_table" "public" {
  for_each = var.public_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-route-table"

  dynamic "route_rules" {
    for_each = var.create_internet_gateway ? [1] : []
    content {
      network_entity_id = oci_core_internet_gateway.this[0].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/route-table/public"
    }
  )
}

resource "oci_core_route_table" "private" {
  for_each = var.private_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-route-table"

  dynamic "route_rules" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      network_entity_id = oci_core_nat_gateway.this[0].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }

  dynamic "route_rules" {
    for_each = var.create_service_gateway ? var.service_gateway_services : []
    content {
      network_entity_id = oci_core_service_gateway.this[0].id
      destination       = route_rules.value.cidr_block
      destination_type  = "SERVICE_CIDR_BLOCK"
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/route-table/private"
    }
  )
}

resource "oci_core_route_table_attachment" "public" {
  for_each = var.public_subnets

  subnet_id      = oci_core_subnet.public[each.key].id
  route_table_id = oci_core_route_table.public[each.key].id
}

resource "oci_core_route_table_attachment" "private" {
  for_each = var.private_subnets

  subnet_id      = oci_core_subnet.private[each.key].id
  route_table_id = oci_core_route_table.private[each.key].id
}

locals {
  public_ingress_rules = var.public_subnet_ingress_rules
  public_egress_rules = var.public_subnet_egress_rules != null ? var.public_subnet_egress_rules : [
    { protocol = "all", destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", description = "Allow all outbound traffic", tcp_options = null, udp_options = null, icmp_options = null },
  ]
  private_ingress_rules = [
    for r in var.private_subnet_ingress_rules : merge(r, { source = coalesce(r.source, var.vcn_cidr_blocks[0]) })
  ]
  private_egress_rules = var.private_subnet_egress_rules != null ? var.private_subnet_egress_rules : [
    { protocol = "all", destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", description = "Allow all outbound traffic", tcp_options = null, udp_options = null, icmp_options = null },
  ]
}

resource "oci_core_security_list" "public" {
  for_each = var.public_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-security-list"

  dynamic "ingress_security_rules" {
    for_each = local.public_ingress_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      description = ingress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.tcp_options != null ? [ingress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }
      dynamic "udp_options" {
        for_each = ingress_security_rules.value.udp_options != null ? [ingress_security_rules.value.udp_options] : []
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }
      dynamic "icmp_options" {
        for_each = ingress_security_rules.value.icmp_options != null ? [ingress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = try(icmp_options.value.code, 0)
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = local.public_egress_rules
    content {
      protocol         = egress_security_rules.value.protocol
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type
      description      = egress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.tcp_options != null ? [egress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }
      dynamic "udp_options" {
        for_each = egress_security_rules.value.udp_options != null ? [egress_security_rules.value.udp_options] : []
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }
      dynamic "icmp_options" {
        for_each = egress_security_rules.value.icmp_options != null ? [egress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = try(icmp_options.value.code, 0)
        }
      }
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/security-list/public"
    }
  )
}

resource "oci_core_security_list" "private" {
  for_each = var.private_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-security-list"

  dynamic "ingress_security_rules" {
    for_each = local.private_ingress_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      description = ingress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.tcp_options != null ? [ingress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }
      dynamic "udp_options" {
        for_each = ingress_security_rules.value.udp_options != null ? [ingress_security_rules.value.udp_options] : []
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }
      dynamic "icmp_options" {
        for_each = ingress_security_rules.value.icmp_options != null ? [ingress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = try(icmp_options.value.code, 0)
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = local.private_egress_rules
    content {
      protocol         = egress_security_rules.value.protocol
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type
      description      = egress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.tcp_options != null ? [egress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }
      dynamic "udp_options" {
        for_each = egress_security_rules.value.udp_options != null ? [egress_security_rules.value.udp_options] : []
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }
      dynamic "icmp_options" {
        for_each = egress_security_rules.value.icmp_options != null ? [egress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = try(icmp_options.value.code, 0)
        }
      }
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/vcn/security-list/private"
    }
  )
}
